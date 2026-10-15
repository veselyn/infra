{
  description = "infra";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    flake-parts.url = "github:hercules-ci/flake-parts/main";
    devenv.url = "github:cachix/devenv/v2.0.5";
    treefmt-nix.url = "github:numtide/treefmt-nix/main";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    git-hooks.url = "github:cachix/git-hooks.nix/master";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux"];

      perSystem = {
        pkgs,
        system,
        ...
      }: {
        devShells.default = inputs.devenv.lib.mkShell {
          inherit inputs pkgs;

          modules = [
            {
              env = {
                CLOUDFLARE_ACCESS_KEY_ID = "op://veselyn/cloudflare api token/access_key_id";
                CLOUDFLARE_ACCOUNT_ID = "op://veselyn/cloudflare api token/account_id";
                CLOUDFLARE_API_TOKEN = "op://veselyn/cloudflare api token/credential";
                CLOUDFLARE_SECRET_ACCESS_KEY = "op://veselyn/cloudflare api token/secret_access_key";
                TF_VAR_cloudflare_account_id = "op://veselyn/cloudflare api token/account_id";
                TF_VAR_op_service_account_token = "op://veselyn/service account auth token/credential";
                TF_VAR_op_vault = "op://veselyn/service account auth token/username";
              };

              languages = {
                nix.enable = true;
                terraform.enable = true;
                terraform.package = pkgs.terraform;
              };

              packages = builtins.attrValues {
                inherit
                  (pkgs)
                  _1password-cli
                  envsubst
                  just
                  pre-commit
                  terraform-docs
                  ;
              };

              treefmt = {
                enable = true;
                config = {
                  programs = {
                    alejandra.enable = true;
                    prettier.enable = true;
                    terraform.enable = true;
                    terraform.package = pkgs.terraform;
                  };
                };
              };

              git-hooks.hooks = {
                deadnix.enable = true;
                end-of-file-fixer.enable = true;
                statix.enable = true;
                terraform-docs = {
                  enable = true;
                  entry = "just check-docs";
                  files = "\\.tf$";
                  pass_filenames = false;
                };
                terraform-validate.enable = true;
                terraform-validate.package = pkgs.terraform;
                tflint.enable = true;
                treefmt.enable = true;
                trim-trailing-whitespace.enable = true;
                yamllint.enable = true;
              };
            }
          ];
        };

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      };
    };
}
