# Variables
variable "project_key" {
  description = "LaunchDarkly project key"
  type        = string
}

# LaunchDarkly project
resource "launchdarkly_project" "example" {
  key  = var.project_key
  name = "Example Project"
  tags = ["managed-by-terraform"]

  # Define environments within the project
  environments {
    key   = "production"
    name  = "Production"
    color = "EEEEEE"
    tags  = ["managed-by-terraform"]
  }

  environments {
    key   = "development"
    name  = "Development"
    color = "7B42FF"
    tags  = ["managed-by-terraform"]
  }
}

# Feature Flag Definition
resource "launchdarkly_feature_flag" "new_checkout_experience" {
  project_key    = launchdarkly_project.example.key
  key            = "new-checkout-experience"
  name           = "New Checkout Experience"
  description    = "Enable the new checkout UI"
  variation_type = "boolean"

  variations {
    value       = true
    name        = "Enabled"
    description = "The new checkout experience"
  }

  variations {
    value       = false
    name        = "Disabled"
    description = "The old checkout experience"
  }

  defaults {
    on_variation  = 0 # Use the "Enabled" variation when targeting is on
    off_variation = 1 # Use the "Disabled" variation when targeting is off
  }

  tags = ["managed-by-terraform", "checkout", "ui"]
}

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

# Production environment flag settings
resource "launchdarkly_feature_flag_environment" "new_checkout_prod" {
  flag_id = launchdarkly_feature_flag.new_checkout_experience.id
  env_key = "production"

  on = true

  # Initially disabled in production
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
