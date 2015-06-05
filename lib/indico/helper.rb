require 'base64'

module Indico
  private

  def self.url_join(root, api)
    if !root
      'https://apiv2.indico.io/' + api
    else
      Indico.cloud_protocol + root + '.indico.domains/' + api
    end
  end

  def self.api_handler(data, api, config)
    server = nil
    api_key = nil
    unless config.nil?
      if config.has_key?('cloud')
        server = config[:cloud]
      end
      if config.has_key?('api_key')
        api_key = config[:api_key]
      end
    end
    d = {}
    d['data'] = data

    unless config.nil?
      config.each do |option, value|
        unless ['cloud','api_key'].include?(option)
          d[option.to_s] = value
        end
      end
    end

    data_dict = JSON.dump(d)

    if api_key.nil?
      api_key = Indico.config['auth']
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

    if url.index('https') == 0
      http.use_ssl = true
    end

    request = Net::HTTP::Post.new(uri.request_uri)
    request.body = data_dict

    headers.each do |key, val|
      request[key] = val
    end

    http.request(request)
  end

  def self.add_api_key_to_header(api_key)
    if api_key.nil?
      raise ArgumentError, 'api key is required'
    end
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'text/plain' }
    headers['X-ApiKey'] = api_key
    headers
  end
end
