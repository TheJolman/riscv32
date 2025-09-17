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
      in {
        packages.default =
          pkgs.stdenv.mkDerivation {};

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            verilator # compiler/simulator
            iverilog # another compiler/simulator
            verible # language server
            gtkwave # we might need this?
            gnumake
          ];
        };
      }
    );
}
