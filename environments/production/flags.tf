# Production environment flag settings
resource "launchdarkly_feature_flag_environment" "new_checkout_prod" {
  flag_id = launchdarkly_feature_flag.new_checkout_experience.id
  env_key = "production"

  on = true

  # Default to disabled in production
  fallthrough {
    variation = 1
  }

  # Beta testers get the feature enabled
  rules {
    description = "Beta testers"

    clauses {
      attribute = "email"
      op        = "endsWith"
      values    = ["@example.com"]
    }

    variation = 0
  }

  off_variation = 1
}

variable "project_key" {
  description = "LaunchDarkly project key"
  type        = string
}
