module Indico
  def self.results_api_handler(data, server, api)
    data_dict = JSON.dump({'data' => data})
    response = make_request(url_join(server, api), data_dict, HEADERS)
    results = JSON.parse(response.body)
    if results.key?("error")
      results["error"]
    else
      Indico::Results.new results["results"]
    end
  end

  def self.language(test_text, server="remote")
    results_api_handler(test_text, server, "language")
  end

  def self.political(test_text, server="remote")
    results_api_handler(test_text, server, "political")
  end

  def self.text_tags(test_text, server="remote")
    results_api_handler(test_text, server, "texttags")
  end

  def self.fer(face, server="remote")
    results_api_handler(test_text, server, "fer")
  end
end
