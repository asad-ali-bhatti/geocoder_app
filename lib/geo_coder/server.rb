require 'socket'
require 'pry'

module Server
  extend self

  #infinite function which process each request coming to server
  def run
    while session = tcp_server.accept
      request = session.gets
      print request
      status, headers, body = rack_app.call({})
      session.print "HTTP/1.1 #{status}\r\n"
      headers.each do |key, value|
        session.print "#{key}: #{value}\r\n"
      end
      session.print "\r\n"
      body.each do |part|
        session.print part
      end
      session.close
    end
  end

  def tcp_server
    @tcp_server ||=  TCPServer.new 3000
  end

  def rack_app(request)
    Proc.new do |request|
      ['200', {'Content-Type' => 'text/html'}, ["Hello world! The time is #{Time.now}"]]
    end
  end
end