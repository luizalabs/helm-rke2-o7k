{{/*
Node scripts to run arbitrary codes on cluster nodes through DaemonSets
*/}}
{{- define "cluster-rke2-openstack.nodeScript" }}
{{- range .Values.rke.nodeScripts }}
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-script-{{ .name }}
  namespace: kube-system
  labels:
    script: {{ .name }}
spec:
  selector:
    matchLabels:
      script: {{ .name }}
  updateStrategy:
    type: RollingUpdate
  template:
    metadata:
      labels:
        name: node-script-{{ .name }}
        script: {{ .name }}
    spec:
      priorityClassName: system-node-critical
      hostNetwork: true
      {{- if .volumes }}
      volumes:
      {{- toYaml .volumes.entries | nindent 6 }}
      {{- end }}
      initContainers:
      - image: {{ .image | default "alpine:3.8" }}
        name: node-script-{{ .name }}
        command:
        {{- toYaml .script | nindent 8 }}
        {{- if .env }}
        env:
        {{- toYaml .env | nindent 8 }}
        {{- end }}
        securityContext:
          privileged: true
        {{- if .volumes }}
        volumeMounts:
        {{- toYaml .volumes.volumeMounts | nindent 8 }}
        {{- end }} 
      containers:
        # @todo parametize
      - image: {{ .pauseContainerImage }} 
        name: pause
      tolerations:
        {{- if $.runOnControlPlanes }}
        - key:
          operator: Exists
        {{- end}}
---
{{- end }}
{{- end }}