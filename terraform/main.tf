terraform {
  required_providers {
    neon = {
      source  = "kislerdm/neon"
      version = "0.9.0"
    }
  }
}

provider "neon" {}

// neon project
resource "neon_project" "this" {
  name = "terraform-test"
}

// neon branch
// when creating a project, a default `main` branch is created automatically
// we can either use that or create a new one as below
resource "neon_branch" "this" {
  project_id = neon_project.this.id
  name       = "terraform-test"
}

// neon role
// default role is also created automatically when creating a project
// we can either use that or create a new one as below
resource "neon_role" "this" {
  project_id = neon_project.this.id
  name       = "tomek"
  branch_id  = neon_branch.this.id
}

// neon database
// default database is also created automatically when creating a project
// we can either use that or create a new one as below
resource "neon_database" "this" {
  project_id = neon_project.this.id
  name       = "terraform-test"
  owner_name = neon_role.this.name
  branch_id  = neon_branch.this.id
}

// this is actually neon's "compute" resource
// for some reason (probably historical) it's called "endpoint"
// documentation uses the term "compute" and "endpoint" interchangeably
// documentation: https://neon.tech/docs/manage/endpoints
resource "neon_endpoint" "this" {
  autoscaling_limit_min_cu = 0.25
  autoscaling_limit_max_cu = 0.5
  project_id               = neon_project.this.id
  branch_id                = neon_branch.this.id
  type                     = "read_write"
}

// read replica
resource "neon_endpoint" "read_only" {
  autoscaling_limit_min_cu = 0.25
  autoscaling_limit_max_cu = 0.5
  project_id               = neon_project.this.id
  branch_id                = neon_branch.this.id
  type                     = "read_only"
}


