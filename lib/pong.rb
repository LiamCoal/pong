class Pong; end

require "pong/paddle"
require "pong/player"
require "pong/network"
require "liamiam/tools"
require "pong/ball"
require "pong/math/angles"
require 'ruby2d'

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
    @ball = Ball.new(self, (width / 2) - 7.5, (height / 2) - 7.5, 15)
    @ls = Text.new(
      '0',
      x: 50, y: 10,
      font: 'lib/ARCADECLASSIC.TTF',
      size: 48,
      color: 'gray',
      rotate: 0,
      z: 1000
    )
    @rs = Text.new(
      '0',
      x: (@width) - (48 + 25), y: 10,
      font: 'lib/ARCADECLASSIC.TTF',
      size: 48,
      color: 'gray',
      rotate: 0,
      z: 1000
    )
    Line.new(
      x1: width / 2, y1: 0,
      x2: width / 2, y2: height,
      width: 10,
      color: 'silver',
      z: -1000
    )
    @hosting = options[:join].nil?
    ball.reset
  end

  def in_bounds?(x, y)
    return :x if x < 0 || x >= width
    return :y if y < 0 || y >= height
    true
  end

  def send_paddle_position
    network.send("P:%i" % player.paddle.position)
  end

  def send_ball_position
    network.send("B:%i,%i" % [ball.x, ball.y])
  end

  def send_scores
    network.send("S:%i,%i" % [opponent.score, player.score])
  end

  def recv_paddle_position(position, ballx, bally)
    opponent.paddle.move(position)
    ball.move ballx, bally
  end

  def handle_mouse_event(e)
    player.handle_mouse_event(e)
  end

  def handle_score_update
    @ls.text = "#{@l.score}"
    @rs.text = "#{@r.score}"
  end

  def handle_update
    handle_score_update
    send_ball_position if @hosting
    send_scores if @hosting
    send_paddle_position
    while message = network.recv
      message0 = message.split(':')
      if message0[0] ==  'B'
        ballpos = message0[1].split(',')
        ballx = ballpos[0].to_i
        bally = ballpos[1].to_i
        recv_paddle_position opponent.paddle.position, ballx, bally
      elsif message0[0] == 'P'
        paddlepos = message0[1].to_i
        recv_paddle_position paddlepos, ball.x, ball.y
      elsif message0[0] == 'S'
        s = message0[1].split(',')
        os = s[0].to_i
        ps = s[1].to_i
        opponent.score = os
        player.score = ps
      elsif message0[0] == 'l'
        player.score = message0[1].to_i unless hosting
        
        puts "#{message0[1]} misses. Opponent: #{player.score} Losing: #{(message0[1].to_i <= player.score)}" if hosting
        puts "opponent: #{message0[1]} misses. Opponent: #{opponent.score} Losing: #{(message0[1].to_i <= opponent.score)}" unless hosting
      elsif message0[0] == 'r'
        opponent.score = message0[1].to_i unless hosting

        puts "#{message0[1]} misses. Opponent: #{player.score} Losing: #{(message0[1].to_i <= player.score)}" unless hosting
        puts "opponent: #{message0[1]} misses. Opponent: #{opponent.score} Losing: #{(message0[1].to_i <= player.score)}" if hosting
      else
        puts "WARN: Ignoring message #{message}. It's invalid."
      end
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