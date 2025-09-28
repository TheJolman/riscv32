with import <nixpkgs> {};
pkgsCross.riscv32-embedded.mkShell {
  packages = with pkgs; [
    iverilog
    verilator
    gtkwave
    gnumake
    bat
  ];
}
