storage "dynamodb" {
  ha_enabled    = "true"
  redirect_addr = "%%VAULT_REDIRECT_ADDR%%"
  cluster_addr  = "%%VAULT_CLUSTER_ADDR%%"
  region        = "%%AWS_REGION%%"
  table         = "%%AWS_DYNAMODB_TABLE%%"
}

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_disable = %%TLS_DISABLE%%
  tls_cert_file = "%%TLS_CERT_FILE%%"
  tls_key_file = "%%TLS_KEY_FILE%%"
}

disable_mlock = true

