require 'socket'

host = '127.0.0.1'
# host = 'overmind-a.kaeuferportal.eu'
socket = UDPSocket.new.tap{|s| s.connect(host, 6666) }

ARGF.each_line do |l|
  #puts l
  #stamp, avg, peak = *l.split(' ')
  #event = %Q({"@message":"soundlevel", "peak":#{peak}, "avg":#{avg}, "type":"soundlevel", "source":"rmokbox"})
  socket.write(l)
end
