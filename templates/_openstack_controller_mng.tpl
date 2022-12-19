{{/*
OpenStack Cloud controller Manager
*/}}
{{ define "cluster-rke2-openstack.openstack-controller-manager" }}
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
    name: openstack-cloud-controller-manager
    namespace: kube-system
spec:
    bootstrap: true
    chart: openstack-cloud-controller-manager
    repo: https://kubernetes.github.io/cloud-provider-openstack
    targetNamespace: kube-system
    valuesContent: |-
        controllerExtraArgs: |-
            - --cluster-name={{ $.Values.cluster.name }}
        logVerbosityLevel: 2
        secret:
            create: true
            name: cloud-config
        tolerations:
            - effect: NoSchedule
              key: node-role.kubernetes.io/control-plane
            - effect: NoExecute
              key: node-role.kubernetes.io/etcd
            - effect: NoSchedule
              key: node.cloudprovider.kubernetes.io/uninitialized
              value: "true"
        cloudConfig:
            global:
                auth-url: {{ $.Values.openstack.authUrl }}
                application-credential-id: {{ $.Values.openstack.applicationCredentialId }}
                application-credential-secret: {{ $.Values.openstack.applicationCredentialSecret }}
                region: {{ $.Values.openstack.region }}
            loadBalancer:
                {{- if .Values.rke.openstackControllerManager }}
                create-monitor: {{ $.Values.rke.openstackControllerManager.enableLoadBalancerCreateMonitor }}
                {{- else }}
                create-monitor: false
                {{- end }}
                monitor-delay: 60s
                monitor-timeout: 30s
                monitor-max-retries: 5
                use-octavia: true
                cascade-delete: true
                subnet-id: {{ $.Values.openstack.subnetID }}
                floating-network-id: {{ $.Values.openstack.floatingNetID }}
            block_storage:
                ignore-volume-az: true
        {{- if .Values.rke.openstackControllerManager }}
        {{- if .Values.rke.openstackControllerManager.image }}
        image:
          repository: {{ $.Values.imageRegistryURL }}{{ $.Values.rke.openstackControllerManager.image }}
        {{- if .Values.rke.openstackControllerManager.tag }}
          tag: {{ $.Values.rke.openstackControllerManager.tag }}
        {{- end }}
        {{- end }}
        {{- end }}
---
{{ end }}