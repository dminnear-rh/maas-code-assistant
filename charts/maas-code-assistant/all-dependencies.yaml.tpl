global:
  wildcardDomain: ${INGRESS_DOMAIN}
  wildcardCertName: ${INGRESS_CERTIFICATE}
  toolsImage: image-registry.openshift-image-registry.svc:5000/openshift/tools:latest

keycloak:
  enabled: true
devspaces:
  enabled: true
grafana:
  enabled: true
cluster-monitoring:
  enabled: true
