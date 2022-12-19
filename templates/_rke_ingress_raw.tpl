{{/*
Cluster ingress via raw manifest
*/}}
{{ define "cluster-rke2-openstack.rke-ingress-raw-manifest" }}
{{- if $.Values.rke.rkeIngressRawManifest.enabled }}
apiVersion: helm.cattle.io/v1
kind: HelmChartConfig
metadata:
    annotations:
        meta.helm.sh/release-name: {{ $.Release.Name }}
    name: rke2-ingress-nginx
    namespace: kube-system
spec:
    bootstrap: false
    targetNamespace: kube-system
    valuesContent: |-
        controller:
            hostNetwork: false
            publishService:
                enabled: true
            service:
                enabled: true
            kind: DaemonSet
            tolerations:
                - effect: NoExecute
                  key: CriticalAddonsOnly
                  operator: "Exists"
---
{{- end }}
{{ end }}
