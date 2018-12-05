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

  def overlaps?(a, b)
    return false if a.x1 > b.x3 || a.x3 < b.x1
    return false if a.y1 > b.y3 || a.y3 < b.y1
    return true
  end

  def hit_player?(player)
    return overlaps?(sprite, player.paddle.sprite)
  end

  def reset
    move(pong.width / 2, pong.height / 2)
    go(Pong::Moth::Angles.radians(rand(0..360)), 5)
  end

  def handle_update
    (x, y) = calculate_new_position

    if hit_player?(pong.l)
      bounce(:x)
      move(x + pong.l.paddle.sprite.width, y)
      return
    end

    if hit_player?(pong.r)
      bounce(:x)
      move(x - pong.r.paddle.sprite.width, y)
      return
    end

    sl = pong.in_bounds?(x, y)
    sr = pong.in_bounds?(x + size, y + size)
    if sl == :x || sr == :x
      return pong.score(:l) if sl == :x
      return pong.score(:r) if sr == :x
    elsif sl == :y || sr == :y
      bounce(:y)
      (x, y) = calculate_new_position
    end

    move(x, y)
  end

end