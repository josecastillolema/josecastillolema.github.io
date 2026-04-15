---
title:  "Local Soft-RoCE development workflow with kind"
last_modified_at: 2025-12-28
tags:
  - dev
  - en
  - networks
  - redhat
toc: true
toc_sticky: true
---

**RDMA over Converged Ethernet** (RoCE) is a network protocol which allows remote direct memory access (RDMA) over an Ethernet network. There are multiple RoCE versions, in particular the RoCE v2 protocol exists on top of either the UDP/IPv4 or the UDP/IPv6 protocol and destination port number 4791 has been reserved for RoCE v2.

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
    ```
    link rxe0/1 state ACTIVE physical_state LINK_UP netdev eth0
    ```

4. Check GID setup (this is the tricky part):

    ```bash
    cat /sys/class/infiniband/rxe0/ports/1/gids/0
    ```
    ```
    fe80:0000:0000:0000:c805:5eff:fe37:e715
    ```

    ```bash
    cat /sys/class/infiniband/rxe0/ports/1/gids/1
    ```
    ```
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
    ```
    ```
                    "IPAddress": "172.17.0.2",
    ```

7. Run the test:

    ```bash
    docker exec server-container ib_write_bw -d rxe0 -x 1 -F
    docker exec client-container ib_write_bw -d rxe0 -x 1 -F 172.17.0.2
    ```
    ```
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

We will be using [k8s-netperf](https://github.com/cloud-bulldozer/k8s-netperf/) as the kubernetes network benchmarking tool. k8s-netperf supports `ib_write_bw` as one of its backends.

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
    ```
    link rxe0/1 state ACTIVE physical_state LINK_UP netdev eth0
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

5. Create the kind cluster (works perfectly fine with podman as well, just export `KIND_EXPERIMENTAL_PROVIDER=podman`):

    ```bash
    kind create cluster --config kind-config-rdma.yaml
    ```
    ```
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
    ```
    ```
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

### Single node cluster

1. You can also create a one node all-in-one kind cluster:

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
    ```

2. Label the one node:

    ```bash
    k8s-netperf --config config.yaml --hostNet --privileged --ib-write-bw rxe0:1 --local
    ```

3. Don't forget the `--local` flag when invoking k8s-netperf:

    ```bash
    k8s-netperf --config config.yaml --hostNet --privileged --ib-write-bw rxe0:1 --local
    ```

## GitHub actions

### First attempt (not working)

For the first attempt we tried using the **Ubuntu Azure github runner OS**. Ubuntu Azure kernel lacks soft-RoCE (`rdma_rxe`) but has the **soft-iWARP** (`siw`) driver instead:

```yaml
name: RoCE

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@master

      - name: Setup Soft-RoCE
        run: |
          sudo apt-get install -y linux-modules-extra-$(uname -r)
          sudo modprobe siw
          sudo rdma link add siw0 type siw netdev eth0
          rdma link show

      - uses: engineerd/setup-kind@v0.6.2
        with:
          config: testing/kind-config-rdma.yaml
          version: "v0.27.0"

      - name: Labeling
        run: |
          kubectl label node kind-control-plane node-role.kubernetes.io/worker=""

      - name: Runs k8s-netperf
        run: |
          git clone --depth 1 https://github.com/josecastillolema/k8s-netperf.git
          cd k8s-netperf
          go build -o k8s-netperf cmd/k8s-netperf/k8s-netperf.go
          ./k8s-netperf --config config.yaml --hostNet --privileged --ib-write-bw siw0:0 --local
```

Unfortunately this elegant and quick worflow does not work. It fails at QP RTS transition. The following kernel ring buffer entry points to something related to running on a Docker veth interface:
```
eth0: renamed from vethf90b642
```

We have tried running `ib_write_bw` with the `-R` flag to use RDMA CM (Connection Manager) instead of manual / IB-style QP setup but even that did not work.

### Final attempt

Since we were unable to make soft-iWARP work we opted for running the workload on a **QEMU Fedora virtual machine with soft-RoCE**. The workflow takes approximately 30 minutes:

 - It spins a Fedora 43 virtual machine with 2 vCPUs and 7 GB of memory
 - Resizes the image to 10 GB
 - Through cloud-init:
   - Installs `kernel-modules-extra` to load the `rdma_rxe` driver
   - Makes some `sysctl` adjustments to prevent the too many open files error
   - Installs `kind` and `kubectl`
   - Deploys a single node kind cluster using the podman provider
   - Runs the `k8s-netperf` workload

```yaml
name: RoCE

on:
  pull_request:
    branches: [ "*" ]
    paths-ignore:
    - '**.md'
    - '**.sh'

jobs:
  qemu:
    runs-on: ubuntu-latest
    timeout-minutes: 45

    steps:
      - name: Checkout k8s-netperf
        uses: actions/checkout@v4

      - name: Build k8s-netperf
        run: |
          make build

      - name: Install dependencies
        run: |
          sudo apt-get update
          sudo apt-get install -y \
            qemu-system-x86 \
            qemu-utils \
            genisoimage

      - name: Boot Fedora Cloud Image with QEMU and install Podman + RDMA + Kind
        run: |
          cd /tmp

          FEDORA_CLOUD_URL="https://download.fedoraproject.org/pub/fedora/linux/releases/43/Cloud/x86_64/images"
          FEDORA_IMAGE="Fedora-Cloud-Base-Generic-43-1.6.x86_64.qcow2"
          wget -q "$FEDORA_CLOUD_URL/$FEDORA_IMAGE" -O fedora-cloud.qcow2; then

          # Resize the qcow2 image to 10GB (default 5GB is too small for packages + Kind)
          qemu-img resize fedora-cloud.qcow2 10G

          mkdir -p /tmp/cloud-init
          # Copy Kind config from repository
          cp $GITHUB_WORKSPACE/testing/kind-config-rdma.yaml /tmp/cloud-init/kind-config.yaml
          # Copy k8s-netperf binary and config
          echo "Copying k8s-netperf binary and config..."
          cp $GITHUB_WORKSPACE/bin/amd64/k8s-netperf /tmp/cloud-init/
          cp $GITHUB_WORKSPACE/examples/roce.yml /tmp/cloud-init/

          # Create user-data for cloud-init
          printf '%s\n' \
            '#cloud-config' \
            'users:' \
            '  - default' \
            '  - name: fedora' \
            '    sudo: ALL=(ALL) NOPASSWD:ALL' \
            '    shell: /bin/bash' \
            '' \
            'chpasswd:' \
            '  list: |' \
            '    fedora:fedora' \
            '  expire: false' \
            '' \
            'packages:' \
            '  - podman' \
            '  - rdma-core' \
            '' \
            'runcmd:' \
            '  - set -ex' \
            '  - trap "echo CLOUD_INIT_FAILED; sync; poweroff" ERR' \
            '  - dnf install -y kernel-modules-extra-$(uname -r)' \
            '  - mkdir -p /mnt/cdrom' \
            '  - mount /dev/sr0 /mnt/cdrom || mount /dev/sr1 /mnt/cdrom || mount /dev/sdb /mnt/cdrom || { echo "❌ Failed to mount cloud-init ISO"; echo "FAST_FAIL_MOUNT_ERROR"; poweroff; exit 1; }' \
            '  - cp /mnt/cdrom/kind-config.yaml /tmp/' \
            '  - cp /mnt/cdrom/k8s-netperf /usr/local/bin/' \
            '  - chmod +x /usr/local/bin/k8s-netperf' \
            '  - cp /mnt/cdrom/roce.yml /tmp/' \
            '  - umount /mnt/cdrom' \
            '  - modprobe ib_core || { echo "❌ Failed to load ib_core module"; exit 1; }' \
            '  - modprobe ib_uverbs || { echo "❌ Failed to load ib_uverbs module"; exit 1; }' \
            '  - modprobe rdma_rxe || { echo "❌ Failed to load rdma_rxe module"; exit 1; }' \
            '  - rdma link add rxe0 type rxe netdev ens3 || { echo "❌ Failed to create RXE device"; exit 1; }' \
            '  - rdma link show' \
            '  - sysctl -w kernel.keys.maxkeys=5000' \
            '  - sysctl -w fs.inotify.max_user_watches=2099999999' \
            '  - sysctl -w fs.inotify.max_user_instances=2099999999' \
            '  - sysctl -w fs.inotify.max_queued_events=2099999999' \
            '  - curl -Lo /usr/local/bin/kind https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64' \
            '  - chmod +x /usr/local/bin/kind' \
            '  - KIND_EXPERIMENTAL_PROVIDER=podman kind create cluster --config=/tmp/kind-config.yaml' \
            '  - kind get clusters' \
            '  - curl -Lo /usr/local/bin/kubectl "https://dl.k8s.io/release/v1.31.0/bin/linux/amd64/kubectl"' \
            '  - chmod +x /usr/local/bin/kubectl' \
            '  - kubectl label node kind-control-plane node-role.kubernetes.io/worker=""' \
            '  - k8s-netperf --config /tmp/roce.yml --privileged --ib-write-bw rxe0:1 --hostNet --local' \
            '  - echo "=== RDMA + Podman + Kind + k8s-netperf completed successfully! ==="' \
            '  - sync' \
            '  - poweroff' \
            > /tmp/cloud-init/user-data

          # Create meta-data using printf
          printf '%s\n' \
            'instance-id: rdma-test-vm' \
            'local-hostname: rdma-test' \
            > /tmp/cloud-init/meta-data

          # Create cloud-init ISO
          genisoimage -output /tmp/cloud-init.iso -volid cidata -joliet -rock /tmp/cloud-init/user-data /tmp/cloud-init/meta-data /tmp/cloud-init/kind-config.yaml /tmp/cloud-init/k8s-netperf /tmp/cloud-init/roce.yml

          # Boot QEMU with cloud image in background
          touch /tmp/vm-output.log
          qemu-system-x86_64 \
            -machine accel=tcg \
            -cpu max \
            -m 7168 \
            -smp 2 \
            -drive file=/tmp/fedora-cloud.qcow2,format=qcow2 \
            -drive file=/tmp/cloud-init.iso,format=raw \
            -netdev user,id=net0,dns=8.8.8.8 \
            -device e1000,netdev=net0 \
            -nographic \
            -serial mon:stdio > /tmp/vm-output.log 2>&1 &
          QEMU_PID=$!
          echo "QEMU started with PID $QEMU_PID"

          # Stream logs in real-time
          tail -f /tmp/vm-output.log &
          TAIL_PID=$!

          # Cleanup
          kill $TAIL_PID 2>/dev/null || true
          kill $QEMU_PID 2>/dev/null || true
          sleep 2

          VM_OUTPUT=$(cat /tmp/vm-output.log)
```
