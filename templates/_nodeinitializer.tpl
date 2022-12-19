{{/*
Node initializer to configurate
*/}}
{{- define "calicoNodeInitializer" }}
{{- if eq .Values.cluster.cni.name "calico" }}
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-initializer
  namespace: kube-system
  labels:
    app: default-init
spec:
  selector:
    matchLabels:
      app: default-init
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        name: node-initializer
        app: default-init
    spec:
      priorityClassName: system-node-critical
      hostNetwork: true
      volumes:
      - name: root-mount
        hostPath:
          path: /
      - name: entrypoint
        configMap:
          name: entrypoint
          defaultMode: 0744
      initContainers:
      - image: {{ $.Values.openstack.openstackClientImage }}
        name: node-initializer
        command: ["/scripts/entrypoint.sh"]
        env:
        - name: OS_AUTH_TYPE
          value: v3applicationcredential
        - name: OS_REGION_NAME
          value: {{ $.Values.openstack.region }}
        - name: OS_INTERFACE
          value: public
        - name: OS_AUTH_URL
          value: {{ $.Values.openstack.authUrl }}/v3
        - name: OS_APPLICATION_CREDENTIAL_ID
          value: {{ $.Values.openstack.applicationCredentialId }}
        - name: OS_APPLICATION_CREDENTIAL_SECRET
          value: {{ $.Values.openstack.applicationCredentialSecret }}
        - name: ROOT_MOUNT_DIR
          value: /root
        securityContext:
          privileged: true
        volumeMounts:
        - name: root-mount
          mountPath: /root
        - name: entrypoint
          mountPath: /scripts
      containers:
      - image: google/pause
        name: pause
      tolerations:
        - key:
          operator: Exists
---
{{- end }}
{{- end }}