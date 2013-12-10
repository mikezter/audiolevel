#!/usr/bin/env ruby
require 'socket'

socket = UDPSocket.new.tap{|s| s.connect('overmind-a.kaeuferportal.eu', 6666) }
source = `hostname`

ARGF.each_line do |l|
  stamp, avg, peak = *l.split(' ')
  event = %Q({"@message":"soundlevel", "peak":#{peak}, "avg":#{avg}, "type":"soundlevel", "source":"#{source}"})
  socket.write(event)
end
