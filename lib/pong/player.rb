class Pong::Player
  attr_reader :pong
  attr_reader :paddle

  def initialize(position, pong)
    @pong = pong
    @paddle = Pong::Paddle.new(position, pong)
  end

  def handle_mouse_event(e)
    paddle.handle_mouse_event(e)
  end
end