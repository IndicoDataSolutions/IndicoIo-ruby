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
  
  def self.api_handler(data, api, config, method='predict')
    server = nil
    api_key = nil
    version = nil

    d = {}
    d['data'] = data

    if data.class == Array
      if api != "apis/intersections"
        api += "/batch"
      end
    end

    api += (method != "predict" ? ("/" + method) : "")

    unless config.nil?
      server = config.delete('cloud')
      api_key = config.delete('api_key')
      apis = config.delete(:apis)
      version = config.delete(:version)
      d = d.merge(config)
    end

    api_key = (api_key or Indico.config['auth'])
    server = (server or Indico.config['cloud'])

    if api_key.nil?
      raise ArgumentError, 'api key is required'
    end
    
    url = url_join(server, api) + \
         ("?key=" + api_key) + \
         (apis ? "&apis=" + apis.join(",") : "") + \
         (version ? "&version=" + version : "")

    response = make_request(url, JSON.dump(d),
                            add_api_key_to_header(api_key))

    response.each_header do |key, value|
      if key.downcase == 'x-warning'
        warn value
      end
    end

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
    headers = HEADERS
    headers['X-ApiKey'] = api_key
    headers
  end
end
