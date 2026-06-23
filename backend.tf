terraform {
  backend "gcs" {
    bucket = "theforge-infra-tfstate-deft-accord-496812-k9"
    prefix = "terraform/state"
  }
}
