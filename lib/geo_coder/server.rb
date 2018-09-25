require 'socket'
require 'pry'
require 'json'

module Server
  extend self
  extend RackApp

  attr_accessor :request_str
  #infinite function which process each request coming to server
  def run
    while session = tcp_server.accept
      self.request_str = session.gets
      # Mimicking  actual rails like RACK module
      response = process_request
      print_response session, response
    end
  end

  def tcp_server
    @tcp_server ||=  TCPServer.new 3000
  end

  def print_response(session, response)
    session.print "HTTP/1.1 #{response[:status]}\r\n"
    response[:headers].each do |key, value|
      session.print "#{key}: #{value}\r\n"
    end

    session.print "\r\n"

    response[:body].each do |part|
      session.print part
    end
    session.close
  end
end