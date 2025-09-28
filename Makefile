# Verilog tools
compiler := iverilog
sim := vvp
testbench_name = testbench

# RISC-V toolchain
riscv_prefix := riscv32-none-elf-
riscv_as := $(riscv_prefix)as
riscv_objcopy := $(riscv_prefix)objcopy
riscv_objdump := $(riscv_prefix)objdump
riscv_arch := rv32i
riscv_abi := ilp32

# Directories
srcs := cpu.v testbench.v
builddir := build/
testdir := tests/

# Target names
testbench = $(builddir)$(testbench_name)
test_programs := $(wildcard $(testdir)*.s)
test_bins := $(test_programs:$(testdir)%.s=$(builddir)%.bin)
test_hexs := $(test_programs:$(testdir)%.s=$(builddir)%.hex)
test_dumps := $(test_programs:$(testdir)%.s=$(builddir)%.dump)

all: $(testbench)

# Build simulator
# The testbench usually instantiates the CPU, so we compile them together.
$(testbench): $(srcs)
	@mkdir -p $(builddir)
	$(compiler) -o $@ $^

# Run Testbench with a default test program (if any is defined in testbench.v)
run: $(testbench)
	$(sim) $<

# Assemble all test programs
test-programs: $(test_hexs) $(test_dumps)

# Assemble RISC-V assembly to object file
$(builddir)%.o: $(testdir)%.s
	@mkdir -p $(builddir)
	$(riscv_as) -march=$(riscv_arch) -mabi=$(riscv_abi) $< -o $@

# Convert object to binary
$(builddir)%.bin: $(builddir)%.o
	$(riscv_objcopy) -O binary $< $@

# Convert binary to hex (for Verilog $readmemh)
# NOTE: Errors in hexdump will cause the build to fail.
$(builddir)%.hex: $(builddir)%.bin
	hexdump -v -e '1/4 "%08x\n"' $< > $@

# Generate disassembly for debugging
$(builddir)%.dump: $(builddir)%.o
	$(riscv_objdump) -d $< > $@

# Show disassembly of test program
show-%: $(builddir)%.dump
	@echo "=== Disassembly of $* ==="
	@command -v bat &> /dev/null && bat $< || cat $<

# Run with a specific test program
run-test-%: $(testbench) $(builddir)%.hex
	@echo "Running test: $*"
	$(sim) $(testbench) +testfile=$(builddir)$*.hex

list-tests:
	@echo "Available test programs:"
	@ls $(testdir)*.s 2>/dev/null | sed 's|$(testdir)||' | sed 's|\.s$$||' || echo "No test programs found in $(testdir)"

clean:
	rm -rf $(builddir)

help:
	@echo "Available targets:"
	@echo "  all          - Build the simulator"
	@echo "  run          - Run simulator with default test (if any)"
	@echo "  run-test-X   - Run simulator with specific test program X"
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

.PHONY: all clean run test-programs list-tests help run-test-% show-%
