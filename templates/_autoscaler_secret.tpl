{{- define "cluster-rke2-openstack.autoscalerConfigMap" }}
url: {{ $.Values.cluster.autoscaler.rancherUrl }}
token: {{ $.Values.cluster.autoscaler.rancherToken }}
clusterName: {{ $.Values.cluster.name }}
clusterNamespace: {{ $.Release.Namespace }}
providerIDPrefix: openstack
{{- end }}