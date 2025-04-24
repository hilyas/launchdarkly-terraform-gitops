# Production environment flag settings
resource "launchdarkly_feature_flag_environment" "new_checkout_prod" {
  flag_id = launchdarkly_feature_flag.new_checkout_experience.id
  env_key = "production"

  on = true

  # Roll out to 10% of users
  fallthrough {
    rollout_weights = [10000, 90000] # 10% enabled, 90% disabled (in thousandths of a percent)
  }

  # Beta testers always get the new experience
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
