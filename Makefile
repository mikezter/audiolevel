CFLAGS=-pedantic -Wall
CC=clang
FRAMEWORK=-framework Foundation -framework AVFoundation -framework AudioToolbox

all: audiolevel

audiolevel:
	$(CC) $(CFLAGS) $(FRAMEWORK) $@.m -o $@

list_devices:
	$(CC) $(CFLAGS) $(FRAMEWORK) $@.m -o $@

clean:
	@rm -f audiolevel list_devices

.PHONY: clean audiolevel list_devices
