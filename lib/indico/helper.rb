module Indico
  private

  def self.base_url(c)
    "http://api.indico.io/%s" % c
  end

  def self.make_request(url, data_dict, headers)
    uri = URI(url)

    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    # request.set_form_data({})
    request.body = data_dict

    headers.each do |key, val|
      request[key] = val
    end

    response = http.request(request)

    response
  end
end