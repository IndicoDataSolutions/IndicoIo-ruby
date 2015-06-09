require 'base64'

module Indico
  CLIENT_TO_SERVER = {
    "political" => "political",
    "sentiment" => "sentiment",
    "language" => "language",
    "text_tags" => "texttags",
    "fer" => "fer",
    "facial_features" => "facialfeatures",
    "image_features" => "imagefeatures"
  }

  SERVER_TO_CLIENT = CLIENT_TO_SERVER.invert
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


  def self.multi(data, type, apis, allowed, batch = false, config)
    converted_apis = Array.new
    apis.each { |api|
      if not allowed.include? api
        fail  api + " is not a valid api for " + type + " requests. Please use: " + allowed.join(", ")
      else
        converted_apis.push(CLIENT_TO_SERVER[api])
      end
    }

    if config.nil?
      config = {}
    end

    config["apis"] = converted_apis
    response = api_handler(data, batch ? "apis/batch" : "apis", config)
    results = handle_multi(response)

    results
  end

  def self.handle_multi(results)
    converted_results = Hash.new
    results.each do |key, value|
      converted_results[SERVER_TO_CLIENT[key]] = value
    end
    converted_results
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
