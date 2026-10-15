resource "cloudflare_r2_bucket" "terraform_state" {
  account_id = var.cloudflare_account_id
  name       = "veselyn-terraform-state"
}

module "github_repository" {
  source = "./modules/github-repository"

  for_each = {
    infra          = {}
    issues         = { has_issues = true }
    issues-private = { has_issues = true, visibility = "private" }
  }

  name           = each.key
  description    = try(each.value.description, "")
  visibility     = try(each.value.visibility, "public")
  archived       = try(each.value.archived, false)
  default_branch = local.default_branch
  has_issues     = try(each.value.has_issues, false)
  ruleset        = try(each.value.ruleset, false)
  environments   = try(each.value.environments, [])
  deploy_key     = try(each.value.deploy_key, false)
  op_vault       = var.op_vault
}
