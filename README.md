# neon-terraform-test

To run it locally, get your API key from neon dashboard. Use `.envrc.private` to
set the `NEON_API_KEY` value. `nix` and `direnv` are required.

Then `terraform init`, `terraform apply`. 

Keep in mind that when creating a (terraform managed) project neon creates 
default (non terraform managed) resources for you like a default `main` branch,
default database, default role etc. In my example, we create terraform managed
resources for everything necessary. The `main.tf` includes a minimal set of 
resources needed to have a running database with read-write and read replicas.