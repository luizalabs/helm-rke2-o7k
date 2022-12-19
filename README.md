# Kubernetes RKE2 Cluster on OpenStack Helm Chart

This repository contains a Helm Chart for deploying RKE2 clusters on top of OpenStack.

## Prerequisites

This Chart was tested on:
- OpenStack Ussuri & Yoga
- Rancher v2.6.6 and Rancher v2.6.9

The docker images used as dependencies for this chart are:
- [fork of kubernetes/autoscaler](https://github.com/alcidesmig/autoscaler): https://hub.docker.com/r/luizalabscicdmgc/cluster-autoscaler-amd64
- [k8scloudprovider/cinder-csi-plugin](https://hub.docker.com/r/k8scloudprovider/cinder-csi-plugin)
- [k8scloudprovider/openstack-cloud-controller-manager](https://hub.docker.com/r/k8scloudprovider/openstack-cloud-controller-manager)
- [rancher/openstack-client](https://hub.docker.com/r/openstacktools/openstack-client)

## Parameters

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `cloudprovider`    | Cloud Provider     | `"openstack"`     |
| `imageRegistryURL`    | Registry for pulling images (need to ends with "/" for non-empty)     | ""     |

### Cloud Init

Cloud Init sections allows execute of arbytrary code by [OpenStack cloud-init](https://cloudinit.readthedocs.io/en/latest/topics/examples.html).

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `cloudinit.enable`    | Enable cloud-init     | `false`     |
| `cloudinit.sshPubKeys`    | SSH public keys to be injected into cluster hosts     | []     |
| `cloudinit.bootcmd`    | Commands to be executed only during the first boot     | Item1     |
| `cloudinit.runcmd`    | Commands to be executed on cloud init     | `["touch /tmp/cloud_init"]`     |

### OpenStack parameters

OpenStack general configurations section.

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `openstack.authUrl`    | OpenStack authentication URL     | `https://openstack.example.com:5000`     |
| `openstack.applicationCredentialId`    | Application Credential ID for accessing OpenStack     | ``     |
| `openstack.applicationCredentialSecret`    | Application Credential Secret for accessing OpenStack     | ``     |
| `openstack.availabilityZone`    | Availability Zone name for disks     | `nova`     |
| `openstack.subnetID`    | LB/Amphoras subnet ID (needs to be on same project network)     | ``     |
| `openstack.projectId`    | Cluster project ID     | ``     |
| `openstack.tenantDomainName`    | OpenStack Tenant Domain Name     | `Default`     |
| `openstack.tenantName`    | OpenStack Project name     | ``     |
| `openstack.username`    | Application credential's username     | ``     |
| `openstack.domainName`    | Tenant Domain Name ID     | `default`     |
| `openstack.region`    | OpenStack Region     | `RegionOne`     |
| `openstack.floatingNetID`    | Network ID for FIPs    | ``     |
| `openstack.floatingSubnetID`    | Subnet ID for FIPs      | ``     |
| `openstack.openstackClientImage`    | Any docker image with OpenStack CLI      | `openstacktools/openstack-client`     |

### Cluster parameters

Cluster section allows general cluster configurations.

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `cluster.apiAddr`    | Kubernetes service host address     | `kubernetes.default.svc.cluster.local`     |
| `cluster.apiPort`    | Kubernetes service host port     | `6443`     |
| `cluster.additionalManifests`    | Additional manifests to be created in the cluster     | `[]`     |
| `cluster.secretsEncryption`    | Enable RKE secrets encryption     | `false`     |
| `cluster.name`    | Cluster name     | `placeholder-cluster-name`     |
| `cluster.kubernetesVersion`    | Kubernetes version     | `v1.21.14+rke2r1`     |

### Cluster nodes upgrade strategy

Refers to [kubectl drain options](https://manpages.debian.org/unstable/kubernetes-client/kubectl-drain.1.en.html), access it for more info.

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `cluster.upgradeStrategy.controlPlaneDrainOptions.enabled`    | Enable Control Plane nodes drain custom options    | `false`     |
| `cluster.upgradeStrategy.controlPlaneDrainOptions.deleteEmptyDirData`    | Enable Control Plane drain custom options    | `false`     |
| `cluster.upgradeStrategy.controlPlaneDrainOptions.disableEviction`    | Force drain to use delete, even if eviction is supported    | `false`     |
| `cluster.upgradeStrategy.controlPlaneDrainOptions.gracePeriod`    | Period of time in seconds given to each pod to terminate gracefully    | `0`     |
| `cluster.upgradeStrategy.controlPlaneDrainOptions.ignoreErrors`    | Ignore errors    | `false`     |
| `cluster.upgradeStrategy.controlPlaneDrainOptions.skipWaitForDeleteTimeoutSeconds`    | If pod DeletionTimestamp older than N seconds, skip waiting for the pod    | `0`     |
| `cluster.upgradeStrategy.controlPlaneDrainOptions.timeout`    | Enable Control Plane drain custom options    | `false`     |
| `cluster.upgradeStrategy.workerDrainOptions.enabled`    | Enable Worker nodes drain custom options     | `false`     |
| `cluster.upgradeStrategy.workerDrainOptions.deleteEmptyDirData`    | Enable Control Plane drain custom options    | `false`     |
| `cluster.upgradeStrategy.workerDrainOptions.disableEviction`    | Force drain to use delete, even if eviction is supported    | `false`     |
| `cluster.upgradeStrategy.workerDrainOptions.gracePeriod`    | Period of time in seconds given to each pod to terminate gracefully    | `0`     |
| `cluster.upgradeStrategy.workerDrainOptions.ignoreErrors`    | Ignore errors    | `false`     |
| `cluster.upgradeStrategy.workerDrainOptions.skipWaitForDeleteTimeoutSeconds`    | If pod DeletionTimestamp older than N seconds, skip waiting for the pod    | `0`     |
| `cluster.upgradeStrategy.workerDrainOptions.timeout`    | Timeout for draining nodes    | `0`     |

### Cluster Autoscaler parameters

This sections defines cluster's autoscaler.

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `cluster.autoscaler.enabled`    | Enable cluster autoscaler    | `false`     |
| `cluster.autoscaler.rancherUrl`    | Rancher URL    | `https://rancher.placeholder.com`     |
| `cluster.autoscaler.rancherToken`    | Rancher Token for autoscaler    | `rancher-token`     |
| `cluster.autoscaler.image`    | Cluster autoscaler image    | `luizalabscicdmgc/cluster-autoscaler-amd64:dev`     |

### Cluster monitoring parameters

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `cluster.monitoring`    | Install cluster Rancher monitoring    | `false`     |

### RKE configurations parameters

This section allow Rancher RKE2 configurations.

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `rke.rkeIngressChart.enabled`    | Install cluster default ingress via ingress chart     | `true`     |
| `rke.rkeIngressChart.replicaCount`    | Ingress replicas (for Ingress via chart)     | `"1"`     |
| `rke.rkeIngressChart.autoScaling.enabled`    | Enable Ingress autoscaling (for Ingress via chart)     | `true`     |
| `rke.rkeIngressChart.autoScaling.minReplicas`    | Ingress autoscaling minimum of replicas (for Ingress via chart)     | `"1"`     |
| `rke.rkeIngressChart.autoScaling.maxReplicas`    | Ingress autoscaling maximum of replicas (for Ingress via chart)     | `"3"`     |
| `rke.rkeIngressRawManifest.enabled`    | Install cluster default ingress via raw manifest    | `false`     |
| `rke.etcd.args`    | Custom etcd args    | `["quota-backend-bytes=858993459", "max-request-bytes=33554432"]`     |
| `rke.etcd.exposeMetrics`    | Expose etcd metrics    | `true`     |
| `rke.etcd.snapshotRetention`    | etcd snapshot retention   @TODO é days? | `5`     | 
| `rke.etcd.snapshotScheduleCron`    | Snapshot cron schedule    | `"0 */12 * * *"`     |
| `rke.coredns.nodelocal.enabled`    | Enable CoreDNS NodeLocal    | `true`     |
| `rke.openstackControllerManager.image`    | openstack-cloud-controller-manager image (omit field for official)    | `k8scloudprovider/openstack-cloud-controller-manager`     |
| `rke.openstackControllerManager.tag`    | openstack-cloud-controller-manager image tag (omit field for official)    | `v1.24.0`     |
| `rke.openstackControllerManager.enableLoadBalancerCreateMonitor`    | Create Load Balancer monitor    | `false`     |
| `rke.openstackControllerManager.cinderCsiPlugin.image`    | cinder-csi-plugin image (omit field for official)     | `k8scloudprovider/cinder-csi-plugin`     |
| `rke.openstackControllerManager.cinderCsiPlugin.tag`    | cinder-csi-plugin image tag (omit field for official)     | `v1.25.0`     |
| `rke.agentEnvVars`    | RKE Agent Environment vars    | `[]`     |
| `rke.kubeapi.args`    | Custom args for KubeAPI    | `[]`     |
| `rke.kubelet.args`    | Custom args for Kubelet    | `[]`     |
| `rke.localClusterAuthEndpoint.enabled`    | Enable out-of-rancher cluster authentication    | `false`     |
| `rke.localClusterAuthEndpoint.fqdn`    | FQDN for out-of-rancher cluster authentication    | `example.rancher.local`     |
| `rke.localClusterAuthEndpoint.secretName`    | Certificate secret name for out-of-rancher cluster authentication    | `example-rancher-local-secret`     |
| `rke.tlsSan`    | Cluster tls-san    | `[]`     |

#### RKE registries configurations parameters

This section allows configuring custom registries options (private registries + mirrors). `configs` and `mirrors` sections are exactly as https://docs.rke2.io/install/containerd_registry_configuration/.

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `rke.registries`    | Enable custom registries configurations     | `false`     |
| `rke.configs`    | [official doc](https://docs.rke2.io/install/containerd_registry_configuration/)     | ``     |
| `rke.mirrors`    | [official doc](https://docs.rke2.io/install/containerd_registry_configuration/)     | ``     |

#### Cluster custom scripts 

This section allows the installation of DaemonSets for running on cluster to do arbitrary tasks (example: mount a file from the host and change it).

The `rke.nodeScripts` is a list of scripts following these structure:

| Name  | Description   | Example   |
|-------------- | -------------- | -------------- |
| `name`    | Node script name     | `script-example-1`     |
| `runOnControlPlanes`    | Run DaemonSet on control planes (+ workers)     | `false`     |
| `script`    | Script to execute     | `["/bin/bash", "-c", "touch /tmp/example_script"]`     |
| `image`    | Node script pod image     | `"ubuntu:22.04"`     |
| `pauseContainerImage`    | Container for running after script     | `pause:2.0`     |
| `env`    | Envs for script pod     | Exactly as pods envs     |
| `volumes.entries`    | Pod volumes     | Exactly as pod volume     |
| `volumes.volumeMounts`    | Pod volume mounts     | Exactly as pod volume mounts     |

### Nodepools parameters

This section defines the nodepools of the cluster. The `cluster.nodepools` section is a list of the following structure:

| Name  | Description   | Example   |
|-------------- | -------------- | -------------- |
| `name`    | Nodepool name     | `wa`     |
| `netId`    | Project network ID for Nodes     | `83512d30-c8e1-4eb7-a5d0-8126b1d75ad2`     |
| `availabilityZone`    | Nodepool's availability zone     | `ne1`     |
| `quantity`    | Nodepool quantity of nodes (override the autoscaler)     | `wa`     |
| `etcd`    | Run etcd on nodes (enable it for Control Planes)     | `false`     |
| `worker`    | Use nodepool's nodes as workers     | `true`     |
| `controlplane`    | Use nodepool's nodes as control planes     | `false`     |
| `bootFromVolume`    |  Set false for using ephemeral disks    | `false`     |
| `volumeSize`    | Volume size, only valid if `bootFromVolume=true`     | `50`     |
| `volumeDevicePath`    | Volume device path, only valid if `bootFromVolume=true`     | `/`     |
| `volumeType`    | Volume type, only valid if `bootFromVolume=true`    | `_DEFAULT_`     |
| `flavorName`    | Nodes flavor     | `general-1`     |
| `imageName`    | Nodes image     | `ubuntu-20.04`     |
| `secGroups`    | Nodes security group     | `default`     |
| `keypairName`    | Keypair name for accessing nodes     | `keypair`     |
| `sshUser`    | SSH user     | `ubuntu`     |
| `sshPort`    | SSH port     | `22`     |
| `activeTimeout`    | Active timeout for nodes (time for instance to be running before recreation)    | `900`     |
| `nodeGroupMaxSize`    | Nodepool max size (for autoscaler)     | `10`     |
| `nodeGroupMinSize`    | Nodepool min size (for autoscaler)     | `1`     |
| `labels`    | Nodes labels     | Key-value of labels       |
| `taints`    | Nodes taints     | List of taints as Kubernetes style    |
| `unhealthyNodeTimeout`    | Nodes unhealthy timeout     | `5m`    |
| `drainBeforeDelete`    | Drain nodes before delete     | `true`    |


## CNI

In order to use the Chart, it is necessary to define one [CNI](https://docs.ranchermanager.rancher.io/v2.5/faq/container-network-interface-providers) for the cluster. We've already tested the Chart using `canal`, `calico` and `cilium`.

| Name  | Description   | Default value   |
|-------------- | -------------- | -------------- |
| `cluster.cni.name`    | CNI to be used    | `cilium`     |


### Using cni=canal

For using the canal CNI, it is necessary to add on `spec.rkeConfig.chartValues` (`cluster.yaml` file) the following content:

```yaml
rke2-canal:
    calico:
        vethuMTU: 1430 # MTU is configurable, we've tested with 1430
```

It can be done adding this code section into chart values `rke.additionalChartValues` section.

### Using cni=calico

For using the calico CNI, it is necessary to add on `spec.rkeConfig.chartValues` (`cluster.yaml` file) the following content:

```yaml
rke2-calico:
    certs:
    node: {}
    typha: {}
    installation:
    calicoNetwork:
    bgp: Enabled
    ipPools:
    - blockSize: 24                     # can be changed
        cidr: 10.42.0.0/16                # can be changed
        encapsulation: IPIPCrossSubnet
        natOutgoing: Enabled
    mtu: 1430                           # can be changed
    ipamConfig: {}
```

It can be done adding this code section into chart values `rke.additionalChartValues` section.

<!-- Additionally, for calico, it is necessary to run on nodes one script to configurate [Allowed Address Pair](https://docs.openstack.org/developer/dragonflow/specs/allowed_address_pairs.html). It can be done copying the content of `calico_dependencies` into your Helm `./templates` file. -->

### Using cni=cilium

For using the calico CNI, it is necessary to add on `spec.rkeConfig.chartValues` (`cluster.yaml` file) the following content:

```yaml
rke2-cilium:
    cilium:
        mtu: 1430 # can be changed
        hubble:
        metrics:
            enabled:
            - dns:query;ignoreAAAA
            - drop
            - tcp
            - flow
            - icmp
            - http
        relay:
            enabled: true
            image:
                repository: "cilium/hubble-relay"
                tag: "v1.12.1"
        ui:
            backend:
                image:
                    repository: "cilium/hubble-ui-backend"
                    tag: "v0.9.2"
            enabled: true
            frontend:
                image:
                    repository: "cilium/hubble-ui"
                    tag: "v0.9.2"
            replicas: 1
        image:
            repository: "rancher/mirrored-cilium-cilium"
            tag: "v1.12.1"
        nodeinit:
            image:
                repository: "rancher/mirrored-cilium-startup-script"
                tag: "d69851597ea019af980891a4628fb36b7880ec26"
        operator:
            image:
                repository: "rancher/mirrored-cilium-operator"
                tag: "v1.12.1"
        preflight:
            image:
                repository: "rancher/mirrored-cilium-cilium"
                tag: "v1.12.1"
        kubeProxyReplacement: "strict"
        k8sServiceHost: {{ $.Values.cluster.apiAddr }} # put the value of apiAddr here
        k8sServicePort: {{ $.Values.cluster.apiPort }} # put the value of apiPort here
```

It can be done adding this code section into chart values `rke.additionalChartValues` section.

It is also necessary to add to Chart values `.cloudinit.runcmd` the following:

```sh
- sed -i -e '/net.ipv4.conf.*.rp_filter/d' $(grep -ril '\.rp_filter' /etc/sysctl.d/ /usr/lib/sysctl.d/)
- sysctl -a | grep '\.rp_filter' | awk '{print $1" = 0"}' > /etc/sysctl.d/1000-cilium.conf
- sysctl --system
```

## Installing

```
helm install cluster-rke2-openstack -f values.yaml repo/cluster-rke2-openstack
```

# Acknowledgment

This Helm Chart was built on top of https://github.com/rancher/cluster-template-examples, and the documentation was inspired by [Bitnami's documentation style](https://github.com/bitnami/charts/blob/4dd3dddb27048a0f818a3ce7a3dad7fece0d0701/template/CHART_NAME/README.md)
