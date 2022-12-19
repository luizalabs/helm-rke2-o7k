{{/*
Calico setup script for running on nodes
*/}}
{{- define "calicoCNIConfigmap" }}
{{- if eq .Values.cluster.cni.name "calico" }}
kind: ConfigMap
apiVersion: v1
metadata:
  name: entrypoint
  namespace: kube-system
  labels:
    app: default-init
data:
  entrypoint.sh: |
    #!/bin/sh
    echo "Starting configuration"
    echo "nameserver 8.8.8.8" >> /etc/resolv.conf
    cat /etc/resolv.conf
    IP_ADDR=$(ip -f inet addr show ens3|grep -o "inet [0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" | grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*")
    echo "Machine IP: " $IP_ADDR
    MAC_ADDRESS=$(cat /sys/class/net/ens3/address)
    echo "Mac Address: " $MAC_ADDRESS
    ID=$(openstack port list --fixed-ip ip-address=$IP_ADDR -f value -c ID)
    echo "Port ID:" $ID
    openstack port set --allowed-address mac-address=$MAC_ADDRESS,ip-address={{ $.Values.cluster.cni.podCidr | default "10.42.0.0/16" }} $ID
    echo "Configuration Done"
---
{{- end }}
{{- end }}