{{/*
Ingress for local authentication bypassing rancher
*/}}
{{ define "cluster-rke2-openstack.kubeconfigIngress"}}
{{ if $.Values.rke.localClusterAuthEndpoint.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubeconfig
  namespace: default
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: HTTPS
spec:
  rules:
  - host: {{ $.Values.rke.localClusterAuthEndpoint.fqdn | default "direct-external-access.domain.local" }}
    http:
      paths:
      - backend:
          service:
            name: kubernetes
            port:
              number: 443
        path: /
        pathType: Prefix
  tls:
  - hosts:
    - {{ $.Values.rke.localClusterAuthEndpoint.fqdn | default "direct-external-access.domain.local" }}
    secretName: {{ $.Values.rke.localClusterAuthEndpoint.secretName }}
---
{{ end }}
{{ end }}