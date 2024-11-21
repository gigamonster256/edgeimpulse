{
  description = "Edge Impulse development environment";

  inputs = {
    nixpkgs.url = "github:cachix/devenv-nixpkgs/rolling";
    systems.url = "github:nix-systems/default";
    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  outputs = {
    self,
    nixpkgs,
    devenv,
    systems,
    ...
  } @ inputs: let
    forEachSystem = nixpkgs.lib.genAttrs (import systems);
  in {
    packages = forEachSystem (system: {
      devenv-up = self.devShells.${system}.default.config.procfileScript;
    });

    formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

    devShells =
      forEachSystem
      (system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        default = devenv.lib.mkShell {
          inherit inputs pkgs;
          modules = [
            {
              languages.javascript = {
                enable = true;
                npm = {
                  enable = true;
                  install.enable =  true;
                };
              };
              languages.python.enable = true;
              pre-commit.hooks = {
                alejandra.enable = true;
                typos.enable = true;
                clang-format.enable = true;
              };
              packages = with pkgs; [] ++ lib.optional stdenv.isDarwin darwin.IOKit;
              env = {};
              enterShell = ''
                export PATH="$(pwd)/node_modules/.bin:$PATH"
              '';
            }
          ];
        };
      });
  };
}
