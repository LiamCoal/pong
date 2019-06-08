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
  attr_reader :players
  attr_reader :opponent
  attr_reader :network
  attr_reader :ball
  attr_reader :hosting

  def initialize(width, height, addr, options)
    @width = width
    @height = height
    @l = Pong::Player.new(:left, self)
    @r = Pong::Player.new(:right, self)
    @players = { :l => @l, :r => @r }
    @player = l
    @opponent = r
    @network = Pong::Network::UDP.new(addr, 9999)
    @ball = Ball.new(self, width / 2, height / 2)
    @hosting = options[:join].nil?
    ball.reset
  end

  def in_bounds?(x, y)
    return :x if x < 0 || x >= width
    return :y if y < 0 || y >= height
    true
  end

  def send_paddle_position
    network.send("%i:%f,%f" % [player.paddle.position, ball.x, ball.y])
  end

  def recv_paddle_position(position, ballx, bally)
    opponent.paddle.move(position)
    ball.move ballx, bally
  end

  def handle_mouse_event(e)
    player.handle_mouse_event(e)
  end

  def handle_update
    send_paddle_position if @hosting
    if message = network.recv
      puts message.nil?
      message0 = message.split(':')
      paddlepos = message0[0].to_i
      ballpos = message0[1].split(',')
      ballx = ballpos[0].to_i
      bally = ballpos[1].to_i
      recv_paddle_position(paddlepos, ballx, bally)
    end
    
    ball.handle_update if @hosting 
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

  def score(side)
    players[side].score += 1
    ball.reset
    puts players[side].score.to_s
    network.send(side.to_s + ":" + players[side].score.to_s)
  end
end