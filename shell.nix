with import <nixpkgs> {};
pkgsCross.riscv64-embedded.mkShell {
  packages = with pkgs; [
    gnumake
    iverilog
  ];
}
