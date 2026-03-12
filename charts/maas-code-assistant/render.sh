#!/bin/bash

INGRESS_DOMAIN=$(oc get ingresscontroller -n openshift-ingress-operator default -ojsonpath='{.status.domain}' 2>/dev/null)
if [ -z "$INGRESS_DOMAIN" ]; then
  echo "Unable to retrieve ingress configuration from your cluster." >&2
  echo "Are you logged in with oc?" >&2
  oc whoami
  exit 1
fi
export INGRESS_DOMAIN

INGRESS_CERTIFICATE=$(oc get ingresscontroller -n openshift-ingress-operator default -ojsonpath='{.spec.defaultCertificate.name}' 2>/dev/null)
if [ -z "$INGRESS_CERTIFICATE" ]; then
  INGRESS_CERTIFICATE=router-certs-default
  INGRESS_CA="$(oc get secret -n openshift-ingress-operator router-ca -ogo-template='{{ index .data "tls.crt" | base64decode }}')"
else
  INGRESS_CA=""
fi
export INGRESS_CERTIFICATE INGRESS_CA

if [ "$(oc get config.imageregistry cluster -ogo-template='{{ range .status.conditions }}{{ if eq .type "Available" }}{{ .status }}{{ end }}{{ end }}')" = "True" ]; then
  TOOLS_IMAGE=image-registry.openshift-image-registry.svc:5000/openshift/tools:latest
else
  TOOLS_IMAGE=quay.io/openshift-release-dev/ocp-v4.0-art-dev@sha256:e850f92068d8365e68bab663ae7b76be22c0af33f6a7803c5c95f5ee3f3748f4
fi
export TOOLS_IMAGE

cd "$(dirname "$(realpath "$0")")"

eval "cat << EOF > all-dependencies.yaml
$(<all-dependencies.yaml.tpl)
EOF
"

gateway_use_route=false
if ! oc get svc -n openshift-ingress router-default; then
  gateway_use_route=true
elif [ "$(oc get svc -n openshift-ingress router-default -ojsonpath='{.spec.type}')" != "LoadBalancer" ]; then
  gateway_use_route=true
fi
if $gateway_use_route; then
  echo "WARNING: Detected a non-load-balancer ingress configuration. Using a Route to back Gateway API resources." >&2
  cat << 'EOF' >> all-dependencies.yaml
gateways:
  maasDefaultGateway:
    useRoute: true
EOF
fi

echo "${PWD}/all-dependencies.yaml:"
sed 's/^/  /' all-dependencies.yaml
