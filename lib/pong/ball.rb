class Pong::Ball
  attr_reader :pong
  attr_reader :sprite
  attr_reader :x, :y, :size, :angle, :vel

  def initialize(pong, x, y, size = 15)
    @pong = pong
    @size = size
    @sprite = Square.new(
      x: 0, y: 0,
      size: size,
      color: "white"
    )

    move(x, y)
    go(0, 0)

    puts "Ball initallized"
  end

  def move(x, y)
    @x = sprite.x = x
    @y = sprite.y = y
  end

  def go(a, v)
    @angle = a
    @vel = v
  end

  def bounce(surface)
    new_angle = 0
    randangle = Pong::Moth::Angles.radians(rand(-10..10))
    case surface
    when :x
      new_angle = (Pong::Moth::Angles.radians(360) - angle + randangle)
      puts "x bounce from #{angle} to #{new_angle}"
    when :y
      new_angle = (Pong::Moth::Angles.radians(180) - angle + randangle)
      puts "y bounce from #{angle} to #{new_angle}"
    end
    go(new_angle, vel)
  end

  def calculate_new_position
    Pong::Moth::Angles.new_pos(x, y, angle, vel)
  end

  def handle_update
    (x, y) = calculate_new_position

    if (s = pong.in_bounds?(x, y)) != true
      bounce(s)
    elsif (s = pong.in_bounds?(x + size, y + size)) != true
      bounce(s)
    end

    (x, y) = calculate_new_position
    move(x, y)
  end

end