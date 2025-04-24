# Development environment flag settings
resource "launchdarkly_feature_flag_environment" "new_checkout_dev" {
  flag_id = launchdarkly_feature_flag.new_checkout_experience.id
  env_key = "development"

  on = true

  # Always enabled in development
  fallthrough {
    variation = 0
  }

  off_variation = 1
}

# Use data sources to reference resources defined in the main configuration
variable "project_key" {
  description = "LaunchDarkly project key"
  type        = string
}
