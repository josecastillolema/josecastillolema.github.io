---
title:  "Kubemark on OpenShift"
last_modified_at: 2023-09-19
tags:
  - en
  - networks
  - openshift
  - redhat
toc: true
toc_sticky: true
---

[Kubemark](https://github.com/kubernetes/kubernetes/tree/master/cmd/kubemark) is a performance testing tool which allows users to run experiments on simulated clusters, by creating "hollow" Kubernetes nodes. What this means is that the nodes do not actually run containers or attach storage, but they do behave like they did, with updates to etcd and all the trimmings. At the same time, **hollow nodes are extremely light (<30 MiB)**.

The primary use case of Kubemark is scalability testing, as simulated clusters can be much bigger than the real ones. The objective is to expose problems with the master components (API server, controller manager or scheduler) that appear only on bigger clusters (e.g. small memory leaks).

## Hands to work

We won't be using the [Cluster API Kubemark Provider](https://github.com/kubernetes-sigs/cluster-api-provider-kubemark/) for this demo, and instead we will be using directly Kubemark itself.

Let's assume we have a **working OpenShift cluster** available. We will be leveraging a [Red Hat OpenShift Local instance](https://developers.redhat.com/products/openshift-local/overview) (formerly Red Hat CodeReady Containers) for this demo:
```
❯ oc version
Client Version: 4.13.6
Kustomize Version: v4.5.7
Server Version: 4.13.6
Kubernetes Version: v1.26.6+73ac561

❯ oc get node
NAME                 STATUS   ROLES                         AGE     VERSION
crc-2zx29-master-0   Ready    control-plane,master,worker   54d     v1.26.6+73ac561
```

Let's create a new **project**, **secret** and corresponding **permissions**:
```
❯ oc new-project kubemark
Now using project "kubemark" on server "https://api.crc.testing:6443".

❯ oc create secret generic kubeconfig --from-file=kubeconfig=$KUBECONFIG
secret/kubeconfig created

❯ oc adm policy add-scc-to-user privileged -z default
clusterrole.rbac.authorization.k8s.io/system:openshift:scc:privileged added: "default"
```

Let's create the **Kubemark pod** (which in turn will automatically instantiate a new node):
```yaml
❯ cat <<EOF | oc apply -f -
apiVersion: v1
kind: Pod
metadata:
  labels:
    app: hollow-node
  name: kubemark-node
  namespace: kubemark
spec:
  containers:
    - args:
        - --v=3
        - --morph=kubelet
        - --name=kubemark-node
        - --extended-resources=cpu=1,memory=4G
      command:
        - /kubemark
      image: quay.io/cluster-api-provider-kubemark/kubemark:v1.26.7
      name: hollow-node
      securityContext:
        privileged: true
      volumeMounts:
        - mountPath: /kubeconfig
          name: kubeconfig
        - mountPath: /run/containerd/containerd.sock
          name: containerd-sock
  volumes:
    - name: kubeconfig
      secret:
        defaultMode: 420
        secretName: kubeconfig
    - hostPath:
        path: /run/crio/crio.sock
        type: Socket
      name: containerd-sock
EOF
pod/kubemark-node created
```

## Validation

Let's check the if new node was properly registered:
```
❯ oc get po
NAME             READY   STATUS    RESTARTS   AGE
kubemark-node    1/1     Running   0          5s

❯ oc get node
NAME                 STATUS   ROLES                         AGE     VERSION
crc-2zx29-master-0   Ready    control-plane,master,worker   54d     v1.26.6+73ac561
kubemark-node        Ready    <none>                        4s      v1.26.7
```

The cluster should be healthy:
```
❯ oc get co
NAME                                       VERSION   AVAILABLE   PROGRESSING   DEGRADED   SINCE   MESSAGE
authentication                             4.13.6    True        False         False      12d
cluster-api                                4.13.6    True        False         False      13d
config-operator                            4.13.6    True        False         False      54d
console                                    4.13.6    True        False         False      12d
control-plane-machine-set                  4.13.6    True        False         False      54d
dns                                        4.13.6    True        False         False      12d
etcd                                       4.13.6    True        False         False      54d
image-registry                             4.13.6    True        False         False      12d
ingress                                    4.13.6    True        False         False      54d
kube-apiserver                             4.13.6    True        False         False      54d
kube-controller-manager                    4.13.6    True        False         False      54d
kube-scheduler                             4.13.6    True        False         False      54d
kube-storage-version-migrator              4.13.6    True        False         False      12d
machine-api                                4.13.6    True        False         False      54d
machine-approver                           4.13.6    True        False         False      54d
machine-config                             4.13.6    True        False         False      54d
marketplace                                4.13.6    True        False         False      54d
network                                    4.13.6    True        False         False      54d
openshift-apiserver                        4.13.6    True        False         False      12d
openshift-controller-manager               4.13.6    True        False         False      12d
openshift-samples                          4.13.6    True        False         False      54d
operator-lifecycle-manager                 4.13.6    True        False         False      54d
operator-lifecycle-manager-catalog         4.13.6    True        False         False      54d
operator-lifecycle-manager-packageserver   4.13.6    True        False         False      119m
platform-operators-aggregated              4.13.6    True        False         False      119m
service-ca                                 4.13.6    True        False         False      54d
```

And there should a few pods already "running" in the new hollow node:
```
❯ oc get pods -A --field-selector spec.nodeName=kubemark-node
NAMESPACE                           NAME                                  READY   STATUS     RESTARTS   AGE
hostpath-provisioner                csi-hostpathplugin-8p9j5              4/4     Running    0          17m
openshift-dns                       dns-default-lt7g8                     2/2     Running    0          17m
openshift-dns                       node-resolver-9plz7                   1/1     Running    0          17m
openshift-image-registry            node-ca-x7hq7                         1/1     Running    0          17m
openshift-ingress-canary            ingress-canary-l2mlx                  1/1     Running    0          17m
openshift-machine-config-operator   machine-config-daemon-smq5z           2/2     Running    0          17m
openshift-multus                    multus-7xp8p                          1/1     Running    0          17m
openshift-multus                    multus-additional-cni-plugins-rv6j7   0/1     Init:0/6   0          17m
openshift-multus                    network-metrics-daemon-zh2vz          2/2     Running    0          17m
openshift-network-diagnostics       network-check-target-l85xq            1/1     Running    0          17m
openshift-sdn                       sdn-rv9mb                             2/2     Running    0          17m

```

Let's try to create some pods on the new hollow node:
```
❯ oc run test --image nginx --overrides='{"spec": { "nodeSelector": {"kubernetes.io/hostname": "kubemark-node"}}}'
pod/test created

❯ oc get po -o wide test
NAME   READY   STATUS    RESTARTS   AGE   IP                NODE            NOMINATED NODE   READINESS GATES
test   1/1     Running   0          36s   192.168.192.168   kubemark-node   <none>           <none>
```

## Scale out

Finally, bear in mind that in order to create new hollow nodes you will have to change two fields in the pod definition:
 - The pod name: `metadata.name`
 - The name of the hollow node: `spec.containers.args.--name`
