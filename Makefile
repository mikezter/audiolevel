CFLAGS=-pedantic -Wall

all: audiolevel

audiolevel:
	clang $(CFLAGS) -framework Foundation -framework AVFoundation -framework AudioToolbox audiolevel.m -o $@

clean:
	@rm -f audiolevel

.PHONY: clean audiolevel
