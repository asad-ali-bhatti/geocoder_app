require 'socket'
require 'pry'
require 'json'

module Server
  extend self

  #infinite function which process each request coming to server
  def run
    while session = tcp_server.accept
      request = session.gets
      print request

      # Mimicking  actual rails like RACK module
      status, headers, body = rack_app(request)

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
    request_method, uri = request.split ' '

    response = {}

    if uri.include? '/geocode'  and request_method == 'GET'
      response[:body] = {asad: 'asad'}.to_json
      response[:code] = '200'
    else
      response[:code] = '404'
      response[:body] = 'OooPSsss! Page Not Found!'
    end

    [response[:code], {'Content-Type' => 'application/json'}, [response[:body]]]
  end
end