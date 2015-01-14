require 'socket'

class ChatServer
  def initialize(port)
    @descriptors = Array.new
    @server_socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, Socket::IPPROTO_TCP)
    @server_socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, true)
    server_address = Socket.pack_sockaddr_in(port, '127.0.0.1')
    @server_socket.bind(server_address)
    puts "Chat server started on port #{port}\n"
    @server_socket.listen(5)
    @descriptors << @server_socket
  end

  def run
    loop do
      res = select(@descriptors, nil, nil, nil)

      if !res.empty?
        # iterate through the tagged read descriptors
        res[0].each do |sock|
          #received a connect to the server (listening) socket
          if sock == @server_socket
            accept_new_connection
          elsif sock.eof?
            # received something on a client socket
            str = "Client left #{sock.remote_address.ip_address}:#{sock.remote_address.ip_port}\n"
            broadcast_string(str, sock)
            sock.close
            @descriptors.delete(sock)
          else
            str = "#{sock.remote_address.ip_address}:#{sock.remote_address.ip_port} #{sock.gets}"
            broadcast_string(str, sock)
          end
        end
      end
    end
  end

  private

  def broadcast_string(str, omit_sock)
    @descriptors.each do |sock|
      if sock != @server_socket && sock != omit_sock
        sock.write(str)
      end
    end

    print(str)
  end

  def accept_new_connection
    new_sock, remote_address = @server_socket.accept
    @descriptors << new_sock

    new_sock.write("You're connected to the Ruby chat server\n")

    str = "Client joined #{remote_address.ip_address}:#{remote_address.ip_port}\n"
    broadcast_string(str, new_sock)
  end
end


chat_server = ChatServer.new(2000).run