require 'socket'

my_socket = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
my_address = Socket.pack_sockaddr_in(52033, '127.0.0.1')
my_socket.bind(my_address)
target_address = Socket.pack_sockaddr_in(2000, '127.0.0.1')
my_socket.connect(target_address)
puts my_socket.read
my_socket.close