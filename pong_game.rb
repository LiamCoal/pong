# Copyright Liam and Jeremy Cole

require 'ruby2d'

require 'pong'

pong = Pong.new(800, 400)

angle = 90.0
vel = 1.0

WRD = WordWrapper.new
UDP = Pong::Network::UDP.new(9998)

hosting = true

while true
  WRD.slowsay("Are you hosting? [Y/N] ")
  input = gets.chomp
  if input == "N".downcase
    hosting = false
  elsif input == "Y".downcase
    hosting = true
  else
    WRD.slowsay("Invalid answer", true)
  end

  if hosting
    WRD.slowsay("Well then, lets go!", true)
    pong.serve
    break
  else
    WRD.slowsay("Enter Ip > ")
    ip = gets.chomp
    pong.connect(ip)
    WRD.slowsay("Connected!")
    break
  end
end

set title: "Pong"
set background: "black"
set height: pong.height
set width:  pong.width

on :key do |e|
  #nothing
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