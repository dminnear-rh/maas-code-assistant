global:
  wildcardDomain: ${INGRESS_DOMAIN}
  wildcardCertName: ${INGRESS_CERTIFICATE}
  toolsImage: ${TOOLS_IMAGE}

keycloak:
  ingressCA: |-
$(echo "${INGRESS_CA}" | sed 's/^/    /')

gateways:
  maasDefaultGateway:
    useRoute: ${GATEWAY_USE_ROUTE}

install-operators:
  processed: false
  operators:
    devspaces:
      enabled: true
    openshift-cert-manager-operator:
      enabled: true
    leader-worker-set:
      enabled: true
    grafana-operator:
      enabled: true
    rhods-operator:
      enabled: true
    rhcl-operator:
      enabled: true
    cloudnative-pg:
      enabled: true
    rhbk-operator:
      enabled: true
