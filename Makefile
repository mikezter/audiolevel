all:
	clang -framework Foundation -framework AVFoundation -framework AudioToolbox main.m -o audiolevel

clean:
	@rm -f audiolevel

.PHONY: clean all
