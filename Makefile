compiler := iverilog
sim := vvp
pname = program

srcs := $(wildcard *.v)
builddir := build/
target = $(builddir)$(pname)

# RISC-V toolchain
riscv_prefix := $(riscv-unknown-elf-)
riscv_as := $(riscv_prefix)as
riscv_objcopy := $(riscv_prefix)objcopy
riscv_objdump := $(riscv_prefix)objdump
riscv_arch := rv32i
riscv_abi := ilp32

all: $(target)

$(target): $(srcs)
	@mkdir -p $(builddir)
	$(compiler) -o $@ $^

run: $(target)
	$(sim) $<

clean:
	rm -rf $(builddir)

.PHONY: all clean run
