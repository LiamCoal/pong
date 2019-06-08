require "socket"

class Pong::Network::UDP
  attr_reader :socket
  attr_reader :peer
  attr_reader :port

  def initialize(addr, port)
    @socket = UDPSocket.new
    @port = port

    socket.bind(addr, port)
  end

  def set_peer(peer)
    @peer = peer
  end

  def send(data)
    socket.send(data, 0, peer, port)
  end

  def recv
    result = socket.recvfrom_nonblock(4096, exception: false)
    if result == :wait_readable
      return nil
    end

    if peer == nil
      @peer = result[1][3]
    end

    return result[0]
  end
end