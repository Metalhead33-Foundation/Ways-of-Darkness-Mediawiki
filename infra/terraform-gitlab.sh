#!/bin/sh

ENV=${CI_ENVIRONMENT_SLUG:-unknown}
APP=${CI_PROJECT_PATH_SLUG:-unknown}
NS=${KUBE_NAMESPACE:-default}

echo "Environment: ${ENV}"
echo "Namespace  : ${NS}"

cat <<EOB > backend.tf # language=terraform
terraform {
  backend "http" {
  }
}
EOB

cat << EOC > details.auto.tfvars # language=terraform
gateway_image = "${CI_REGISTRY_IMAGE:-gateway}"

db_name = "${db_name:-mw_wodsonck}"
domain = "${domain:-ways-of-darkness.sonck.nl}"
name_suffix = "${name_suffix:-}"
ssh_host = "${ssh_host:-192.168.254.19}"

environment = "${ENV}"
gitlab_app = "${APP}"

namespace = "${NS}"
EOC