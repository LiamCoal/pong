class Pong
  class Moth
    class Angles

      def self.radians(degrees)
        return degrees/(180.0/Math::PI)
      end

      def self.degrees(radians)
        return radians*(Math::PI/180.0)
      end

      def self.new_pos(x, y, a, v)
        nx = x + (Math.sin(a) * v)
        ny = y - (Math.cos(a) * v)
        return [nx, ny]
      end

      def self.new_pos_deg(x, y, d, v)
        return new_pos(x, y, radians(d), v)
      end
    end
  end
end