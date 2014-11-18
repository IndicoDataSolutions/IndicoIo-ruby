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

  def self.language(test_text, api="remote")
    results_api_handler(test_text, api, "language")
  end

  def self.political(test_text, api="remote")
    results_api_handler(test_text, api, "political")
  end

  def self.text_tags(test_text, api="remote")
    results_api_handler(test_text, api, "texttags")
  end

  def self.fer(face, api="remote")
    results_api_handler(test_text, api, "fer")
  end
end
