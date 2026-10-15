provider "github" {
  owner = "veselyn"
}

provider "onepassword" {
  service_account_token = var.op_service_account_token
}
