{
  description = "RISC-V CPU development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
      riscv-pkgs = pkgs.pkgsCross.riscv64-embedded;
    in {
      devShells.default = riscv-pkgs.mkShell {
        buildInputs = with pkgs; [
          # Verilog simulation tools
          iverilog
          gtkwave

          # Development tools
          gnumake
          hexdump
        ];
      };
    });
}
