class Pong; end

require "pong/paddle"
require "pong/player"
require "pong/network"
require "liamiam/tools"
require "pong/ball"
require "pong/math/angles"

class Pong
  attr_reader :width
  attr_reader :height
  attr_reader :l
  attr_reader :r
  attr_reader :player
  attr_reader :opponent
  attr_reader :network
  attr_reader :ball

  def initialize(width, height)
    @width = width
    @height = height
    @l = Pong::Player.new(:left, self)
    @r = Pong::Player.new(:right, self)
    @player = l
    @opponent = r
    @network = Pong::Network::UDP.new(9999)
    @ball = Ball.new(self, width / 2, height / 2)
    ball.go(Pong::Moth::Angles.radians(0), 3)
  end

  def in_bounds?(x, y)
    return :x if x < 0 || x >= width
    return :y if y < 0 || y >= height
    true
  end

  def send_paddle_position
    network.send("%i" % player.paddle.position)
  end

  def recv_paddle_position(position)
    opponent.paddle.move(position)
  end

  def handle_mouse_event(e)
    player.handle_mouse_event(e)
    send_paddle_position
  end


  def handle_update
    if message = network.recv
      recv_paddle_position(message.to_i)
    end

    ball.handle_update
  end

  def serve
    @player = l
    @opponent = r

    puts "Waiting for join..."
    while network.peer == nil
      message = network.recv
      if message == "hi"
        puts "%s joined!" % network.peer
      end
    end
    sleep 0.5
    print "."
  end

  def connect(peer)
    @player = r
    @opponent = l

    network.set_peer(peer)
    network.send("hi")
  end

end