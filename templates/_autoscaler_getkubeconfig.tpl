{{- define "cluster-rke2-openstack.autoscalerKubeconfig" }}
#!/bin/sh
CLUSTER_ID=$(curl -s -H "Authorization: Bearer {{ $.Values.cluster.autoscaler.rancherToken }}" {{ $.Values.cluster.autoscaler.rancherUrl }}/v3/clusters?name={{ $.Values.cluster.name }} | jq -r .data[].id)
curl -s -u {{ $.Values.cluster.autoscaler.rancherToken }} {{ $.Values.cluster.autoscaler.rancherUrl }}/v3/clusters/$CLUSTER_ID?action=generateKubeconfig -X POST -H 'content-type: application/json' --insecure | jq -r .config
{{- end }}