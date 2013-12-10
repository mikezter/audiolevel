#!/usr/bin/env ruby
require 'socket'

socket = UDPSocket.new.tap{|s| s.connect('overmind-a.kaeuferportal.eu', 6666) }

ARGF.each_line do |l|
  puts l
  stamp, avg, peak = *l.split(' ')
  event = %Q({"@message":"soundlevel", "peak":#{peak}, "avg":#{avg}, "type":"soundlevel", "source":"rmokbox"})
  socket.write(event)
end
