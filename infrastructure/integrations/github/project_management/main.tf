terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  owner = "egjimenezg"
}

resource "github_repository" "elixir_cluster" {
  name               = "elixir_cluster"
  description        = "Distributed Elixir Cluster"
  visibility         = "public"
  auto_init          = true
  gitignore_template = "Elixir"
}

