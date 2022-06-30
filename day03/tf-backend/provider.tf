terraform {
  required_version = "> 1.2"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.21.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.2.3"
    }
  }

  backend s3 {
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    endpoint = "https://sgp1.digitaloceanspaces.com"
    region = "sgp1"
    bucket = "aipc1234"
    key = "apic/terraform.tfstate"
  }
}

provider digitalocean {
  token = var.DO_token
}

provider local { }
