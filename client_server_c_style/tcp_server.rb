require 'socket'

# This is just creating a socket. The address family is internet and the type of socket is a stream socket
person = Socket.new(Socket::AF_INET, Socket::SOCK_STREAM, 0)
person.setsockopt(Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1)
# This is where my clients can reach me - my hotel is '127.0.0.1' and my room number is 2000.
hotel_and_room_number = Socket.pack_sockaddr_in(2000, '127.0.0.1')
# Go to the hotel room and sit and wait for my client
person.bind(hotel_and_room_number)
# Turn do not disturb sign around and to 'feel free to disturb me' and sit and wait
person.listen(1)
visitor, _ = person.accept
# When someone comes to the door, do some stuff
puts 'Hello, I am the person in the room'
puts "I am #{person.inspect}"
puts "#{visitor.inspect} is visiting"
visitor.puts 'What would you like?'
visitor.puts 'Goodbye. I will close the door now'
puts "I have closed the door on #{visitor.inspect}"
# Close the door
person.close



