class Pong::Paddle
  attr_reader :position
  attr_reader :pong
  attr_accessor :sprite

  PADDLE_WALL_DISTANCE = 20

  WIDTH = 10
  HEIGHT = 50

  def initialize(paddle_position, pong)
    @pong = pong

    case paddle_position
    when :left      
      paddle_x = PADDLE_WALL_DISTANCE
    when :right
      paddle_x = pong.width - PADDLE_WALL_DISTANCE - WIDTH
    end
    
    @sprite = Rectangle.new(
      x: paddle_x,
      y: 0,
      width: WIDTH,
      height: HEIGHT, 
      color: "white"
    )
  end

  def move(y)
    @position = y
    sprite.y = y
  end

  def handle_mouse_event(event)
    if event.y <= 400 - HEIGHT
      move(event.y)
    end
  end
end