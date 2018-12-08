# Copyright Liam and Jeremy Cole

require 'ruby2d'

require 'pong'

pong = Pong.new(800, 400)

angle = 90.0
vel = 1.0

WRD = WordWrapper.new
UDP = Pong::Network::UDP.new(9998)

hosting = ARGV.empty?
ip = ARGV[0]

if hosting
  WRD.slowsay("Well then, lets go!", true)
  pong.serve
else
  pong.connect(ip)
  WRD.slowsay("Connected!")
end

set title: "Pong"
set background: "black"
set height: pong.height
set width:  pong.width

on :key do |e|
  if e.key == :escape
    close
  end
end

on :mouse do |e|
  if e.type == :move
    pong.handle_mouse_event(e)
  end
end

update do
  pong.handle_update
  
end
  
show