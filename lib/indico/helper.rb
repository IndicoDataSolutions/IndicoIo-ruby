require_relative './errors'

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

    d = {}
    d['data'] = data

    unless config.nil?
      server = config[:cloud]
      api_key = config[:api_key]
      apis = config["apis"]
      d = d.merge(config)
    end

    url = url_join((server or Indico.config['cloud']), api) +
          (apis ? "?apis=" + apis.join(",") : "")

    response = make_request(url, JSON.dump(d),
                            add_api_key_to_header((api_key or Indico.config['auth'])))


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
    headers = HEADERS
    headers['X-ApiKey'] = api_key
    headers
  end
end
