terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "network_saturation_check_for_kafka_nodes" {
  source    = "./modules/network_saturation_check_for_kafka_nodes"

  providers = {
    shoreline = shoreline
  }
}