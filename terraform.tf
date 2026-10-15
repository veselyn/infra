terraform {
  required_version = "~> 1.12"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.13.0"
    }

    github = {
      source  = "integrations/github"
      version = "6.13.0"
    }

    onepassword = {
      source  = "1Password/onepassword"
      version = "2.2.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.2.1"
    }
  }
}
