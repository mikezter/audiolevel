CFLAGS=-pedantic -Wall

all: audiolevel

audiolevel:
	clang $(CFLAGS) -framework Foundation -framework AVFoundation -framework AudioToolbox main.m -o $@

clean:
	@rm -f audiolevel

.PHONY: clean audiolevel
