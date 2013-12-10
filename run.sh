#!/bin/bash
make -s && nohup -- ./audiolevel | ./rsock.rb &
