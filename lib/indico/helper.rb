require 'base64'

module Indico
  private

  def self.url_join(root, api)
    if !root
      'http://apiv2.indico.io/' + api
    else
      'https://' + root + '.indico.domains/' + api
    end
  end

  def self.api_handler(data, server, api, api_key)
    d = {}
    d['data'] = data
    data_dict = JSON.dump(d)

    if api_key.nil?
      api_key = Indico.config['api_key']
    end

    if server.nil?
      server = Indico.config['cloud']
    end

    response = make_request(url_join(server, api), data_dict,
                            add_api_key_to_header(api_key))


    results = JSON.parse(response.body)
    if results.key?('error')
      fail results['error']
    else
      results['results']
    end
  end

  def self.make_request(url, data_dict, headers)
    uri = URI(url)

    http = Net::HTTP.new(uri.host, uri.port)

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = data_dict

    headers.each do |key, val|
      request[key] = val
    end

    http.request(request)
  end

  def self.add_api_key_to_header(api_key)
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'text/plain' }
    headers['Authorization'] = api_key
    headers
  end
end
