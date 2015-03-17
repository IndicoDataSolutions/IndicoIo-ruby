require "base64"

module Indico
  private

  def self.url_join(root, api)
    if root == 'local'
      "http://localhost:9438/%s" % api
    else
      "http://apiv1.indico.io/%s" % api
    end
  end

  def self.api_handler(data, server, api, username=nil, password=nil)
    d = {}
    d['data'] = data
    data_dict = JSON.dump(d)
    if username.nil?
      response = make_request(url_join(server, api), data_dict, HEADERS)
    else
      response = make_request(url_join(server, api), data_dict, encode_credentials(username, password))
    end
    results = JSON.parse(response.body)
    if results.key?("error")
      raise results["error"]
    else
      results = results["results"]
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

  def self.encode_credentials(username, password)
    headers = { "Content-Type" => "application/json", "Accept" => "text/plain" }
    credentials = username + ":" + password
    headers["Authorization"] = "Basic " + Base64.strict_encode64(credentials)
    headers
  end

end
