{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
        crossPkgs = import nixpkgs {
          localSystem.system = "${system}";
          crossSystem.system = "riscv64-none-elf";
        };
      in {
        packages.default =
          pkgs.stdenv.mkDerivation crossPkgs.mkDerivation {
          };

        devShells.default = crossPkgs.riscv64-embedded.mkShell {
          packages = with pkgs; [
            iverilog # compiler/sim
            verible # language server
            gnumake
          ];
        };
      }
    );
}
