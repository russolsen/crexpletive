CR_FILES := $(wildcard src/*.cr src/**/*.cr)

BINARIES = exdump exundump

default: $(BINARIES)

info:
	echo $(CR_FILES)

exdump: $(CR_FILES)
	crystal build -o $@ src/exdump.cr

exundump: $(CR_FILES)
	crystal build -o $@ src/exundump.cr

clean:
	rm -f $(BINARIES)
