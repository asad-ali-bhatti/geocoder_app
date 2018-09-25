class GeoCoder
  extend self

  attr_accessor :params, :response, :request, :request_str

  def extended(base)
    self.request, self.response = {}
    self.params = {}
  end

  def extract_params
    method, uri = request_str.split(' ')
    request[:uri] = uri
  end

  def process_request
    self.response = {}
    self.params = {}

    request_method, uri = request_str.split ' '

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
end