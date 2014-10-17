module Indico
  private

  def self.url_join(root, api)
    if root == 'local'
      "http://localhost:9438/%s" % api
    else
      "http://apiv1.indico.io/%s" % api
    end
  end

  def self.api_handler(data, server, api)
    d = {}
    d['data'] = data
    data_dict = JSON.dump(d)
    response = make_request(url_join(server, api), data_dict, HEADERS)
    results = JSON.parse(response.body)
    if results.key?("error")
      results = results["error"]
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

    response = http.request(request)
  end
end