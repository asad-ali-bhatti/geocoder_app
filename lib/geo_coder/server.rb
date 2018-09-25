require 'socket'
require 'pry'
require 'json'

module Server
  extend self

  #infinite function which process each request coming to server
  def run
    while session = tcp_server.accept
      request = session.gets
      # Mimicking  actual rails like RACK module
      response = rack_app request
      print_response session, response
    end
  end

  def tcp_server
    @tcp_server ||=  TCPServer.new 3000
  end

  def rack_app(request)
    request_method, uri = request.split ' (?<=\?).*'
    @params = HashWithIndifferentAccess.new

    if params_str = uri[/(?<=\?).*/]
      params_str.split('&').each do |vars|
        key, value = var.split('=')
        @params[key] =  value
      end
    end

    @request_uri = uri[/.*(?=\?)/]

    response = { code: '', headers: {'Content-Type': 'application/json'}, body: [] }

    #Controller and Action discovery
    if uri.include? '/geocode'  and request_method == 'GET'
      response[:body] << {asad: 'asad'}.to_json
      response[:code] = '200'
    else
      response[:code] = '404'

      response[:body] << 'OooPSsss! Page Not Found!'
    end

    response
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