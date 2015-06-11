require_relative './errors'

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
      if value.is_a?(Hash) && value.has_key?("results")
        converted_results[SERVER_TO_CLIENT[key]] = value["results"]
      else
        raise IndicoError, 'unexpected result from ' + key + '\n\t' + value.fetch("error", "")
      end
    end
    converted_results
  end
end
