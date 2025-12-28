---
title:  "Local Soft-RoCE development workflows with kind"
last_modified_at: 2025-12-28
tags:
  - dev
  - en
  - networks
  - redhat
toc: true
toc_sticky: true
---

RDMA over Converged Ethernet (RoCE) is a network protocol which allows remote direct memory access (RDMA) over an Ethernet network. There are multiple RoCE versions, in particular the RoCE v2 protocol exists on top of either the UDP/IPv4 or the UDP/IPv6 protocol and destination port number 4791 has been reserved for RoCE v2.

Network-intensive applications like networked storage, cluster computing and Artificial Intelligence workloads need a network infrastructure with a high bandwidth and low latency. The advantages of RDMA over other network application programming interfaces are lower latency, lower CPU load and higher bandwidth.

[Soft-RoCE](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/9/html-single/configuring_infiniband_and_rdma_networks/index#configuring-soft-roce_configuring-roce) is a software implementation of remote direct memory access (RDMA) over Ethernet, which is also called RXE. We can use Soft-RoCE on hosts without RoCE host channel adapters (HCA).

We will be using [ib_write_bw](https://enterprise-support.nvidia.com/s/article/ib-write-bw) as the network benchmarking tool.

## Testing with Docker/Podman

1. Load the software RoCE module:

    ```bash
    sudo modprobe rdma_rxe
    ```

2. Create RXE on the active interface:

    ```bash
    sudo rdma link add rxe0 type rxe netdev eth0
    ```

3. Verify configuration:

    ```bash
    rdma link show
    ```

4. Check GID setup (this is the tricky part):

    ```bash
    cat /sys/class/infiniband/rxe0/ports/1/gids/0
    fe80:0000:0000:0000:c805:5eff:fe37:e715

    cat /sys/class/infiniband/rxe0/ports/1/gids/1
    0000:0000:0000:0000:0000:ffff:c0a8:0117
    ```

    GID 0 is an IPv6 link-local address while GID 1 is an IPv4-mapped IPv6 address:
    - GID 0: `fe80:0000:0000:0000:c805:5eff:fe37:e715` IPv6 link-local address
    - GID 1: `0000:0000:0000:0000:0000:ffff:c0a8:0117` IPv4-mapped IPv6 address - 192.168.1.23

5. Create client/server containers with RDMA access:

    ```bash
    docker run -d --name server-container --privileged \
      --device=/dev/infiniband/uverbs0 \
      --volume=/sys/class/infiniband:/sys/class/infiniband:ro \
      quay.io/cloud-bulldozer/k8s-netperf:latest \
      sleep 3600

    docker run -d --name client-container --privileged \
      --device=/dev/infiniband/uverbs0 \
      --volume=/sys/class/infiniband:/sys/class/infiniband:ro \
      quay.io/cloud-bulldozer/k8s-netperf:latest \
      sleep 3600
    ```

6.  Get server container IP address:

    ```bash
    docker inspect server-container | grep IPAddress | tail -1
                    "IPAddress": "172.17.0.2",
    ```

7. Run the test:

    ```bash
    docker exec server-container ib_write_bw -d rxe0 -x 1 -F
    docker exec client-container ib_write_bw -d rxe0 -x 1 -F 172.17.0.2
    ---------------------------------------------------------------------------------------
                        RDMA_Write BW Test
    Dual-port       : OFF          Device         : rxe0
    Number of qps   : 1            Transport type : IB
    Connection type : RC           Using SRQ      : OFF
    PCIe relax order: ON           Lock-free      : OFF
    ibv_wr* API     : OFF          Using DDP      : OFF
    TX depth        : 128
    CQ Moderation   : 1
    CQE Poll Batch  : 16
    Mtu             : 1024[B]
    Link type       : Ethernet
    GID index       : 1
    Max inline data : 0[B]
    rdma_cm QPs     : OFF
    Data ex. method : Ethernet
    ---------------------------------------------------------------------------------------
    local address: LID 0000 QPN 0x001f PSN 0xeb83da RKey 0x00108c VAddr 0x007fa70d049000
    GID: 254:128:00:00:00:00:00:00:65:153:129:16:120:165:110:231
    remote address: LID 0000 QPN 0x0020 PSN 0xeb83da RKey 0x00115c VAddr 0x007f3a0742d000
    GID: 254:128:00:00:00:00:00:00:65:153:129:16:120:165:110:231
    ---------------------------------------------------------------------------------------
    #bytes     #iterations    BW peak[MiB/sec]    BW average[MiB/sec]   MsgRate[Mpps]
    65536      5000             1032.41            1024.75              0.016396
    ---------------------------------------------------------------------------------------
    ```

    We obtained an average bandwidth of ~1024 MiB/sec.

8. Cleanup. Remove the containers and the RXE device:

    ```bash
    docker rm -f server-container client-container
    sudo rdma link delete rxe0
    ```

## Testing with Kind

We will be using [k8s-netperf](https://github.com/cloud-bulldozer/k8s-netperf/) as the kubernetes network benchmarking tool. k8s-netperf supports ib_write_bw as one of its backends.

1. Load the software RoCE module:

    ```bash
    sudo modprobe rdma_rxe
    ```

2. Create RXE on the active interface:

    ```bash
    sudo rdma link add rxe0 type rxe netdev eth0
    ```

3. Verify configuration:

    ```bash
    rdma link show
    ```

4. Let's create an RDMA enabled kind cluster config `kind-config-rdma.yaml`:

    ```yaml
    kind: Cluster
    apiVersion: kind.x-k8s.io/v1alpha4
    nodes:
      - role: control-plane
        extraMounts:
          - hostPath: /dev/infiniband
            containerPath: /dev/infiniband
          - hostPath: /sys/class/infiniband
            containerPath: /sys/class/infiniband
            readOnly: true
          - hostPath: /sys/class/net
            containerPath: /sys/class/net
            readOnly: true
      - role: worker
        extraMounts:
          - hostPath: /dev/infiniband
            containerPath: /dev/infiniband
          - hostPath: /sys/class/infiniband
            containerPath: /sys/class/infiniband
            readOnly: true
          - hostPath: /sys/class/net
            containerPath: /sys/class/net
            readOnly: true
      - role: worker
        extraMounts:
          - hostPath: /dev/infiniband
            containerPath: /dev/infiniband
          - hostPath: /sys/class/infiniband
            containerPath: /sys/class/infiniband
            readOnly: true
          - hostPath: /sys/class/net
            containerPath: /sys/class/net
            readOnly: true
    ```

5. Create the kind cluster:

    ```bash
    kind create cluster --config kind-config-rdma.yaml
    Creating cluster "kind" ...
     ✓ Ensuring node image (kindest/node:v1.32.2) 🖼
     ✓ Preparing nodes 📦 📦 📦
     ✓ Writing configuration 📜
     ✓ Starting control-plane 🕹️
     ✓ Installing CNI 🔌
     ✓ Installing StorageClass 💾
     ✓ Joining worker nodes 🚜
    ```

6. Label the nodes:

    ```bash
    kubectl label node kind-worker  node-role.kubernetes.io/worker=""
    kubectl label node kind-worker2 node-role.kubernetes.io/worker=""
    ```

7. Create a k8s-netperf config file for RoCEv2 traffic `config.yaml`:

    ```yaml
    ---
    tests:
      - UDPStream:
        parallelism: 1
        profile: "UDP_STREAM"
        duration: 5
        samples: 1
        messagesize: 1024
    ```

8. Run the test:

    ```bash
    k8s-netperf --config config.yaml --hostNet --privileged --ib-write-bw rxe0:1
    INFO[2025-12-28 11:29:38] Starting k8s-netperf (roce2@e2988034e0f9dd4e2a59f131f6ae7866b12fd6de)
    INFO[2025-12-28 11:29:38] 📒 Reading config.yaml file.
    INFO[2025-12-28 11:29:38] 📒 Reading config.yaml file - using ConfigV2 Method.
    WARN[2025-12-28 11:29:38] 😥 Prometheus is not available
    INFO[2025-12-28 11:29:38] 🔨 Creating namespace: netperf
    INFO[2025-12-28 11:29:38] 🔨 Creating service account: netperf
    WARN[2025-12-28 11:29:38] ⚠️  No zone label
    WARN[2025-12-28 11:29:38] ⚠️  Single node per zone and/or no zone labels
    INFO[2025-12-28 11:29:38] 🚀 Starting Deployment for: client-host in namespace: netperf
    INFO[2025-12-28 11:29:38] ⏰ Checking for client-host Pods to become ready...
    INFO[2025-12-28 11:29:56] Looking for pods with label role=host-client
    INFO[2025-12-28 11:29:56] 🚀 Starting Deployment for: server-host in namespace: netperf
    INFO[2025-12-28 11:29:56] ⏰ Checking for server-host Pods to become ready...
    INFO[2025-12-28 11:30:11] Looking for pods with label role=host-server
    INFO[2025-12-28 11:30:16] 🗒️  Running ib_write_bw UDP_STREAM (service false) for 5s
    WARN[2025-12-28 11:30:22] Not able to collect OpenShift specific node info
    +-------------------+-------------+------------+-------------+--------------+---------+-----------------+----------+-------------+--------------+-------+-----------+----------+---------+-------------------+--------------------------+
    |    RESULT TYPE    |   DRIVER    |  SCENARIO  | PARALLELISM | HOST NETWORK | SERVICE | EXTERNAL SERVER | UDN INFO | BRIDGE INFO | MESSAGE SIZE | BURST | SAME NODE | DURATION | SAMPLES |     AVG VALUE     | 95% CONFIDENCE INTERVAL  |
    +-------------------+-------------+------------+-------------+--------------+---------+-----------------+----------+-------------+--------------+-------+-----------+----------+---------+-------------------+--------------------------+
    | 📊 Stream Results | ib_write_bw | UDP_STREAM | 1           | true         | false   | false           |          |             | 1024         | 0     | false     | 5        | 1       | 935.110000 (Mb/s) | 0.000000-0.000000 (Mb/s) |
    +-------------------+-------------+------------+-------------+--------------+---------+-----------------+----------+-------------+--------------+-------+-----------+----------+---------+-------------------+--------------------------+
    +------------------+-------------+------------+-------------+--------------+---------+-----------------+----------+-------------+--------------+-------+-----------+----------+---------+-----------+
    |       TYPE       |   DRIVER    |  SCENARIO  | PARALLELISM | HOST NETWORK | SERVICE | EXTERNAL SERVER | UDN INFO | BRIDGE INFO | MESSAGE SIZE | BURST | SAME NODE | DURATION | SAMPLES | AVG VALUE |
    +------------------+-------------+------------+-------------+--------------+---------+-----------------+----------+-------------+--------------+-------+-----------+----------+---------+-----------+
    | UDP Loss Percent | ib_write_bw | UDP_STREAM | 1           | true         | false   | false           |          |             | 1024         | 0     | false     | 5        | 1       | 0.000000  |
    +------------------+-------------+------------+-------------+--------------+---------+-----------------+----------+-------------+--------------+-------+-----------+----------+---------+-----------+
    INFO[2025-12-28 11:30:22] Cleaning resources created by k8s-netperf
    INFO[2025-12-28 11:30:22] ⏰ Waiting for netperf Namespace to be deleted...
    ```

    The average bandwidth was ~935 MiB/sec.

9. Cleanup. Remove the kind cluster and the RXE device:

    ```bash
    kind delete cluster
    sudo rdma link delete rxe0
    ```