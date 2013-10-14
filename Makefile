CFLAGS=-pedantic -Wall
CC=clang
FRAMEWORK=-framework Foundation -framework AVFoundation -framework AudioToolbox

all: audiolevel

audiolevel:
	$(CC) $(CFLAGS) $(FRAMEWORK) $@.m -o $@

list_devices:
	$(CC) $(CFLAGS) $(FRAMEWORK) $@.m -o $@

readme:
	markdown2 README.md > readme.html && open readme.html

clean:
	@rm -f audiolevel list_devices readme.html

.PHONY: clean audiolevel list_devices readme
