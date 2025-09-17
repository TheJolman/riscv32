# Verilog tools
compiler := iverilog
sim := vvp
pname = program

# RISC-V toolchain
riscv_prefix := riscv64-none-elf-
riscv_as := $(riscv_prefix)as
riscv_objcopy := $(riscv_prefix)objcopy
riscv_objdump := $(riscv_prefix)objdump
riscv_arch := rv32i
riscv_abi := ilp32

# Directories
srcs := $(wildcard *.v)
builddir := build/
testdir := tests/

# Target names
target = $(builddir)$(pname)
test_programs := $(wildcard $(testdir)*.s)
test_bins := $(test_programs:$(testdir)%.s=$(builddir)%.bin)
test_hexs := $(test_programs:$(testdir)%.s=$(builddir)%.hex)
test_dumps := $(test_programs:$(testdir)%.s=$(builddir)%.dump)

all: $(target)

# Build CPI sim
$(target): $(srcs)
	@mkdir -p $(builddir)
	$(compiler) -o $@ $^

# Run CPU sim
run: $(target)
	$(sim) $<

# Assemble RISC-V assembly to object file
$(builddir)%.o: $(testdir)%.s
	@mkdir -p $(builddir)
	$(riscv_as) -march=$(riscv_arch) -mabi=$(riscv_abi) $< -o $@

# Convert object to binary
$(builddir)%.bin: $(builddir)%.o
	$(riscv_objcopy) -O binary $< $@

# Convert binary to hex (for Verilog $readmemh)
$(builddir)%.hex: $(builddir)%.bin
	hexdump -v -e '1/4 "%08x\n"' $< > $@ || echo "" > $@

# Run all test programs
test-programs: $(test_bins) $(test_hexs) $(test_dumps)

# Generate disassembly for debugging
$(builddir)%.dump: $(builddir)%.o
	$(riscv_objdump) -d $< > $@

# Show disassembly of test program
show-%: $(builddir)%.dump
	@echo "=== Disassembly of $* ==="
	@bat $<

# Run with a specific test program
run-test-%: $(target) $(builddir)%.hex
	@echo "Running test: $*"
	$(sim) $(target) +testfile=$(builddir)$*.hex

list-tests:
	@echo "Available test programs:"
	@ls $(testdir)*.s 2>/dev/null | sed 's|$(testdir)||' | sed 's|\.s$$||' || echo "No test programs found in $(testdir)"

clean:
	rm -rf $(builddir)

help:
	@echo "Available targets:"
	@echo "  all          - Build CPU and assemble all test programs"
	@echo "  run          - Run CPU simulator"
	@echo "  run-test-X   - Run CPU with specific test program X"
	@echo "  show-X       - Show disassembly of test program X"
	@echo "  test-programs- Assemble all test programs"
	@echo "  list-tests   - List available test programs"
	@echo "  clean        - Remove build directory"
	@echo "  help         - Show this help"
	@echo ""
	@echo "Directory structure:"
	@echo "  tests/       - Put your .s assembly files here"
	@echo "  build/       - Generated files (hex, bin, dumps)"
	@echo "  *.v          - Your Verilog CPU source files"

.PHONY: all clean run test-programs
