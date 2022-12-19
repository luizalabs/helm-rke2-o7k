{{/*
OpenStack Cinder CSI plugin
*/}}
{{- define "cluster-rke2-openstack.cinderCsiPlugin" }}
apiVersion: helm.cattle.io/v1
kind: HelmChart
metadata:
  annotations:
    meta.helm.sh/release-name: {{ $.Release.Name }}
  name: cinder-csi-plugin
  namespace: kube-system
spec:
  chart: openstack-cinder-csi
  repo: https://kubernetes.github.io/cloud-provider-openstack
  targetNamespace: kube-system
  bootstrap: false
  valuesContent: |+
    storageClass:
          enabled: true
          delete:
              isDefault: false
              allowVolumeExpansion: true
          retain:
              isDefault: false
              allowVolumeExpansion: true
          custom: |-
            ---
            apiVersion: storage.k8s.io/v1
            kind: StorageClass
            metadata:
              name: csi-cinder-default
              annotations:
                storageclass.kubernetes.io/is-default-class: "true"
            allowVolumeExpansion: true
            parameters:
              availability: {{ $.Values.openstack.availabilityZone }}
            provisioner: cinder.csi.openstack.org
            reclaimPolicy: Delete
            volumeBindingMode: Immediate
            ---
            apiVersion: storage.k8s.io/v1
            kind: StorageClass
            metadata:
              name: csi-cinder-nvme
              annotations:
                {}
              labels:
                {}
            allowVolumeExpansion: true
            parameters:
              availability: nova
              type: nvme
            provisioner: cinder.csi.openstack.org
            reclaimPolicy: Retain
            volumeBindingMode: Immediate
    secret:
      enabled: true
      create: true
      name: cinder-csi-cloud-config
      data:
        cloud.conf: |-
          [Global]
          auth-url={{ $.Values.openstack.authUrl }}
          application-credential-id={{ $.Values.openstack.applicationCredentialId }}
          application-credential-secret={{ $.Values.openstack.applicationCredentialSecret }}
          region={{ $.Values.openstack.region }}
          [BlockStorage]
          ignore-volume-az=true
    {{- if .Values.rke.cinderCsiPlugin }}
    {{- if .Values.rke.cinderCsiPlugin.image }}
    csi:
      plugin:
        image:
          repository: {{ $.Values.imageRegistryURL }}{{ $.Values.rke.cinderCsiPlugin.image }}
          {{- if .Values.rke.cinderCsiPlugin.tag }}
          tag: {{ $.Values.rke.cinderCsiPlugin.tag }}
          {{- end }}
    {{- end }}
    {{- end }}
---
{{- end }}