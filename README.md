# 32-bit RISC-V Simulator

## Usage
```sh
nix-shell
make
make run
```

See `make help` for all Makefile commands.

## Project Requirements
- Design and simulate a 32-bit RISC-V CPU that implements a subset of the
RV32I (32-bit base integer, little-endian) instruction set architecture.
- Baseline is a *single-cycle processor* that includes:
    - ALU
    - multiplexors
    - Register file
    - Instruction Fetch and Decode Logic
    - Control Unit (combinational)
    - Data and Instruction Memory

- Project must execute provided test programs correctly

### Suggested Instruction Set
- Arithmetic: `add` ,`sub`, `addi`
- Logical: `and` ,`or`, `xor`
- Shifts: `sll` ,`srl`, `sra`
- Memory: `lw` ,`sw`
- Control: `beq` ,`bne`, `jal`, `jalr`
- Immediate and Utility: `lui` ,`auipc`

### Platform
Verilog?

### Extra Credit


### AI Usage Log
- Used an LLM to assist in setting up the project and Makefile
