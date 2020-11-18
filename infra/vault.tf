resource "vault_kubernetes_auth_backend_role" "mediawiki" {
  role_name                        = kubernetes_service_account.mediawiki.metadata[0].name
  bound_service_account_names      = [kubernetes_service_account.mediawiki.metadata[0].name]
  bound_service_account_namespaces = [kubernetes_service_account.mediawiki.metadata[0].namespace]
  token_ttl                        = 3600
  token_policies                   = ["mw_wodsonck"]
}
