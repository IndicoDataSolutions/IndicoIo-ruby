require_relative './errors'
require_relative './settings'

module Indico
  CLIENT_TO_SERVER = {
    "political" => "political",
    "sentiment" => "sentiment",
    "sentiment_hq" => "sentimenthq",
    "language" => "language",
    "text_tags" => "texttags",
    "fer" => "fer",
    "named_entities" => "namedentities",
    "keywords" => "keywords",
    "facial_features" => "facialfeatures",
    "facial_localization" => "facial_localization",
    "image_features" => "imagefeatures",
    "content_filtering" => "contentfiltering",
    "twitter_engagement" => "twitterengagement",
    "myers_briigs" => "myersbriggs"
  }

  SERVER_TO_CLIENT = CLIENT_TO_SERVER.invert

  def self.validate_apis(apis, type="api", allowed=CLIENT_TO_SERVER.keys)
    apis.each { |api|
      if not allowed.include? api
        fail  api + " is not a valid api for " + type + " requests. Please use: " + allowed.join(", ")
      end
    }
  end

  def self.multi(data, type, apis, allowed, batch = false, config)

    if config.nil?
      config = {}
    end

    self.validate_apis(apis, type, allowed)
    config[:apis] = apis
    response = api_handler(data, batch ? "apis/batch" : "apis", config)
    return handle_multi(response)
  end

  def self.intersections(data, apis = nil, config = nil)

    if apis == nil
      fail "Argument 'apis' must be provided"
    end

    api_types = apis.map { |api| API_TYPES[api] }

    if !apis.is_a? Array or apis.length != 2
      fail "Argument 'apis' must be of length 2"
    elsif data.is_a? Array and data.length < 3
      fail "At least 3 examples are required to use the intersections api"
    elsif api_types[0] != api_types[1]
      fail "Both 'apis' must accept the same kind of input to use the intersections api."
    end

    if config.nil?
      config = {}
    end

    self.validate_apis(apis)
    config[:apis] = apis
    response = api_handler(data, "apis/intersections", config)
    return response

  end

  def self.handle_multi(results)
    converted_results = Hash.new
    results.each do |key, value|
      if value.is_a?(Hash) && value.has_key?("results")
        converted_results[key] = value["results"]
      else
        raise IndicoError, 'unexpected result from ' + key + '. ' + value.fetch("error", "")
      end
    end
    converted_results
  end
end
