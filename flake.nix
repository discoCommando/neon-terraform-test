{
  description = "Neon terraform test";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.devshell.url = "github:numtide/devshell";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";

  outputs = inputs@{ self, flake-parts, nixpkgs, devshell }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        devshell.flakeModule
      ];

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "i686-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      perSystem = { pkgs, system, ... }:
        {
          _module.args.pkgs = import nixpkgs {
            inherit system;
            config = {
              # This is needed to get Terraform 1.11, due to the license change
              allowUnfree = true;
            };
          };

          devshells.default = {
            name = "neon-terraform-test";

            packages = with pkgs; [
              terraform
              coreutils
            ];

            env = [
            ];
          };
        };
    };
}