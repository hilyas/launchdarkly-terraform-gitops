terraform {
  backend "gcs" {
    bucket = "terraform-launchdarkly-gitops-state-playground-20231012"
    prefix = "terraform/state"
  }
}
