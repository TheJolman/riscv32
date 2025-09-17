with import <nixpkgs> {};
pkgsCross.riscv64-embedded.mkShell {
  packages = with pkgs; [
    iverilog
    verilator
    gtkwave
    gnumake
    bat
  ];
}
