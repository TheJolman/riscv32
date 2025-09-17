compiler := iverilog
pname = program

srcs := $(wildcard *.v)
builddir := build/
target = $(builddir)$(pname)

all: $(target)

$(target): $(srcs)
	@mkdir -p $(builddir)
	$(compiler) -o $@ $^

run: $(target)
	vvp $<

clean:
	rm -rf $(builddir)

.PHONY: all clean run
