global:
  wildcardDomain: ${INGRESS_DOMAIN}
  wildcardCertName: ${INGRESS_CERTIFICATE}
  toolsImage: ${TOOLS_IMAGE}

keycloak:
  enabled: true
  ingressCA: |-
$(echo "${INGRESS_CA}" | sed 's/^/    /')
devspaces:
  enabled: true
grafana:
  enabled: true
cluster-monitoring:
  enabled: true
