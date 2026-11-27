locals {
  common_tags = {
    Workload    = "inventory"
    Environment = "dev"
    ManagedBy   = "terraform"
    Project     = "platform-engineer-bootcamp"

  }
}