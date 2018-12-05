class Pong::Player
  attr_reader :pong
  attr_reader :paddle
  attr_accessor :score

  def initialize(position, pong)
    @pong = pong
    @paddle = Pong::Paddle.new(position, pong)
    @score = 0
  end

  def handle_mouse_event(e)
    paddle.handle_mouse_event(e)
  end
end