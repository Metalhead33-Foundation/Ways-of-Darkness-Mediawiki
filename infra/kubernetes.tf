locals {
  labels = {
    environment = var.environment
    application = "mediawiki"
    customer = "metalhead33"
    "redmonitor.cofano.io/category" = "sites"
  }
  annotations = {
    "app.gitlab.com/app" = var.gitlab_app
    "app.gitlab.com/env" = var.environment
  }
  name = "${var.environment}-mediawiki"
}

provider "kubernetes" {

}

locals {
  db_host = "postgres.${var.namespace}"
  db_port = 5432
}

resource "kubernetes_service_account" "mediawiki" {
  metadata {
    name = local.name
    namespace = var.namespace
    labels = local.labels
  }
}

resource "kubernetes_persistent_volume_claim" "mediawiki" {
  metadata {
    name = local.name
    labels = local.labels
    namespace = var.namespace
  }
  spec {
    storage_class_name = "mediawiki"
    access_modes = [
      "ReadWriteMany"]
    selector {
      match_labels = local.labels
    }
    resources {
      requests = {
        storage = "5Gi"
      }
      limits = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "mediawiki" {
  depends_on = [
    kubernetes_cluster_role_binding.mediawiki]
  metadata {
    name = local.name
    namespace = var.namespace
    labels = merge(local.labels, {
      "component" = "wiki"
    })
    annotations = local.annotations
  }
  spec {
    selector {
      match_labels = merge(local.labels, {
        "component" = "wiki"
      })
    }
    template {
      metadata {
        labels = merge(local.labels, {
          "component" = "wiki"
        })
        annotations = merge(local.annotations, {
          "vault.hashicorp.com/agent-inject" = "true"
          "vault.hashicorp.com/agent-init-first" = "true"
          "vault.hashicorp.com/agent-limits-cpu" = "2m"
          "vault.hashicorp.com/agent-requests-cpu" = "1m"
          "vault.hashicorp.com/agent-inject-secret-db-creds.php" = "database/creds/mw_wodsonck"
          "vault.hashicorp.com/agent-inject-template-db-creds.php" = <<-EOT
            {{- with secret "database/creds/mw_wodsonck" -}}
            <?php
            $wgDBtype = '${var.db_type}';
            $wgDBserver = '${local.db_host}';
            $wgDBname = '${var.db_name}';
            $wgDBport = ${local.db_port};
            $wgDBmwschema = '${var.db_schema}';
            $wgDBuser = '{{ .Data.username }}';
            $wgDBpassword = '{{ .Data.password }}';
            {{ end }}
          EOT
          "vault.hashicorp.com/role" = vault_kubernetes_auth_backend_role.mediawiki.role_name
        })
      }
      spec {
        volume {
          name = "wiki-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mediawiki.metadata[0].name
          }
        }
        service_account_name = kubernetes_service_account.mediawiki.metadata[0].name
        automount_service_account_token = true
        init_container {
          name = "update"
          image = "${var.app_image}:${var.app_version}"
          command = [
            "php",
            "maintenance/update.php"]
          env {
            name = "MW_SITE"
            value = "https://${var.domain}"
          }
          env {
            name = "MW_CONFIRMACCOUNT"
            value_from {
              secret_key_ref {
                name = var.wiki_secret
                key = "confirm-account"
              }
            }
          }
          env {
            name = "MW_SECRETKEY"
            value_from {
              secret_key_ref {
                name = var.wiki_secret
                key = "secret-key"
              }
            }
          }
          env {
            name = "MW_UPGRADEKEY"
            value_from {
              secret_key_ref {
                name = var.wiki_secret
                key = "upgrade-key"
              }
            }
          }
          volume_mount {
            mount_path = "/var/www/html/images"
            name = "wiki-data"
          }
        }

        container {
          name = "main"
          image = "${var.app_image}:${var.app_version}"
          env {
            name = "MW_SITE"
            value = "https://${var.domain}"
          }
          env {
            name = "MW_CONFIRMACCOUNT"
            value_from {
              secret_key_ref {
                name = var.wiki_secret
                key = "confirm-account"
              }
            }
          }
          env {
            name = "MW_SECRETKEY"
            value_from {
              secret_key_ref {
                name = var.wiki_secret
                key = "secret-key"
              }
            }
          }
          env {
            name = "MW_UPGRADEKEY"
            value_from {
              secret_key_ref {
                name = var.wiki_secret
                key = "upgrade-key"
              }
            }
          }
          volume_mount {
            mount_path = "/var/www/html/images"
            name = "wiki-data"
          }

          port {
            container_port = 80
            name = "http"
            protocol = "TCP"
          }

          liveness_probe {
            http_get {
              path = "/Main_Page"
              port = "http"
            }
            timeout_seconds = 120
            period_seconds = 3600
          }
          readiness_probe {
            http_get {
              path = "/Main_Page"
              port = "http"
            }
            timeout_seconds = 10
            failure_threshold = 12
          }
        }
      }
    }
  }
}

resource "kubernetes_deployment" "mediawiki-admin" {
  metadata {
    name = "${local.name}-admin"
    labels = merge(local.labels, {
      "component" = "admin"
    })
    annotations = local.annotations
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = merge(local.labels, {
        "component" = "admin"
      })
    }
    template {
      metadata {
        labels = merge(local.labels, {
          "component" = "admin"
        })
        annotations = local.annotations
      }
      spec {
        volume {
          name = "wiki-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.mediawiki.metadata[0].name
          }
        }
        volume {
          name = "hostkeys"
          secret {
            default_mode = "0700"
            secret_name = "hostkeys"
          }
        }
        volume {
          name = "auth"
          config_map {
            default_mode = "0755"
            name = kubernetes_config_map.mediawiki-admin.metadata[0].name
          }
        }
        service_account_name = kubernetes_service_account.mediawiki.metadata[0].name
        automount_service_account_token = true
        container {
          name = "main"
          image = "docker2.touhou.fm/tools/mediawiki-admin:latest"
          volume_mount {
            mount_path = "/mnt"
            name = "wiki-data"
          }
          volume_mount {
            mount_path = "/config/hostkeys"
            name = "hostkeys"
          }
          volume_mount {
            mount_path = "/home/mediawiki/.ssh/authorized_keys"
            name = "auth"
            sub_path = "authorized_keys"
          }

          port {
            container_port = 3022
            name = "ssh"
            protocol = "TCP"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "mediawiki" {
  metadata {
    name = local.name
    labels = local.labels
    namespace = var.namespace
  }
  spec {
    type = "ClusterIP"
    port {
      port = 80
      target_port = "http"
      protocol = "TCP"
      name = "http"
    }
    selector = merge(local.labels, {
      "component" = "wiki"
    })
  }
}

resource "kubernetes_ingress" "mediawiki" {
  metadata {
    name = local.name
    namespace = var.namespace
    labels = local.labels
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-sonck-prod"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.mediawiki.metadata[0].name
            service_port = 80
          }
        }
      }
      host = var.domain
    }
    tls {
      hosts = [
        var.domain]
      secret_name = "${replace(var.domain, ".", "-")}-tls"
    }
  }
}

resource "kubernetes_cluster_role_binding" "mediawiki" {
  metadata {
    name = local.name
    labels = local.labels
  }
  role_ref {
    kind = "ClusterRole"
    name = "system:auth-delegator"
    api_group = "rbac.authorization.k8s.io"
  }
  subject {
    kind = "ServiceAccount"
    name = kubernetes_service_account.mediawiki.metadata[0].name
    namespace = kubernetes_service_account.mediawiki.metadata[0].namespace
  }
}

resource "kubernetes_config_map" "mediawiki-admin" {
  metadata {
    name = local.name
    labels = merge(local.labels, {
      "component" = "admin"
    })
    namespace = var.namespace
  }
  data = {
    authorized_keys = <<EOC
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDASaGKEgjHU72oxQW2tCV87dG7p5rR9CPEcC/nLSAzq4kfFSJkavvQTHuA+PGx0Heg2xvwo/1AnLhsIYDfUjlsCsnLpDfztN/D2r8nspPCIVpgwwBuN9XT5twLRIcBsWperhSj9AQBA2Hnxwc9SsqQLGQn8PEN/FmoEX/eK7REUH40OuuGRgfMtxK6fqdrAZWC5c+/yxEux8afx2eXaimuvrzn4Ct4gluT3RIbM+2Nnvk/dNn4SruIiyUPpN1viJX0mECYrMSRkgT/tiyh/sbh4eGhkGj96M7V5VPMmC/w/w1b1+E7l+ahcpnqYqrfDmsjajs8el7cqJ+x+PGd/2ud id_secure
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC754oUEnhxZN1KUHg6U1HS5S9w7H0Tvdpp9MFuBksHowdSvUugQ54pUpgeLQj6ULlUp9ZZ3gMgZUC9ngfsKJJOlyAsyQu0KwtgugU/4KC5FL6zcco14i6u19Ft2Qz2RKf4fzVY68T68g1bPxqo6QTtqRqotfddkEWZWN17gdVgyjHa0y4lmNbujuZtpEsd14ibZXHQ3At70hXVIuTwxBg+qfAtkhmwXEH+7KyH42E1ot0RQW7ljS6wgQa27lXO3RvSTUYRedWvwofBKFgBC7pOYGIFHixZvfRUgZHSA6n8ktSP/4xZudXIj905iPrxfWSmHsqheaxxONkCVgQJv2ez metalhead33@localhost
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDI6CyEZT0WXD2rhK/jMbW4xiJSynsBp01N82WAUH79xqTECu9IwhyS2oC9Zl/puJLKwEnFBU3n2vO0S2SAtax2obpb6PNdiUirTwYV9UQiuKtkB3R7APkRFjouRr6LY9uHMrx5RyD819IRDQpCGNEo9hCc42l8UBHvlKQJ+6Ki5ZMjRpjlR1UuiRwvOx5PMnlTgV+p/qc0sIKV6Kr7MaOhziG9dOjbFwu59x+p/ii/N30db3Khs8RHMAffEdAckN9Uizw+Ow1NYOyB/4ZvwVne0fdHFfFI6H4AsfzoUShRLHCo0sqKnyJVzONKW+M8WBKWroit2HBeHuxD9soEywWv tzsolt@kaguya
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC6lV+0RrLHZRcXJlzgUelaV1c1IpXrW6ajpktDcZ/vlaxrCStK/e16kMYsxv5PG2cqs+KB3b9sv3YCGmRL1VqxeOBDjCPDA3ryYGFNZLQzLYVJQ+AK9hzhxICJBoLB+4KEeV/+AMK29/8oh6iXoIJJpW8akVsPjw1kTOxu2NV4OfK167xIR82dwq9kq3oIKhfSLxHgCVlHoM33aYIYYLfidDC7pNeYaoz/cpuOXsXC1OEH7LIsaxg5QQaZMjMZpUOLwiYcmTFpwliBKNOSBOLh2JHS1HlzyMPeofkR0SlhKwQYM4LdNTI45oksP4qNQ706JCvznzxRuGzMiy6FjUzClOJRcSldb4IBjh1ZfRLHP0LNmuiUc+Q4jKb0zYky2BahqcPAg5dCLDJzHJUiByVaJZtEYoO3rNPUnFaVWMFT1axqVLFI6LqJPq4hKpfLaLLbyTR9z8VeCsgmKK7qipEDHOoQyRPDOuNTX1ybUromxmsKP39FwAcgZWMXX7k3eVqT4OM58YCA19KqrqUvpsVq6vm5Gf3fE5YKDkga/fLsppb+adH2UHZVtow43Wuxsoz2eSZvCYh3jtt2cfTPSczStcbwhCywHENUsG+6L34ZkK4uZn//Ad8E18tEf+g8YnWpSyVWN3PXkCapGN1tgDtlkO3eDJUbZ+Ab87xYd0a9tQ== wasofdarkness@gmail.com
EOC
  }
}

resource "kubernetes_service" "mediawiki-admin" {
  metadata {
    name = "${local.name}-admin"
    labels = merge(local.labels, {
      "component" = "admin"
    })
    namespace = var.namespace
  }
  spec {
    selector = merge(local.labels, {
      "component" = "admin"
    })
    port {
      name = "ssh"
      protocol = "TCP"
      port = 22
      target_port = "ssh"
    }
    type = "LoadBalancer"
    load_balancer_ip = var.ssh_host
    external_traffic_policy = "Local"
  }
}