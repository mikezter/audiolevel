all:
	clang -v -framework Foundation -framework AVFoundation -framework AudioToolbox main.m -o audiolevel
