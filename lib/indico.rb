require "indico/version"
require "indico/helper"
require "uri"
require "json"
require "net/https"

module Indico

  HEADERS = { "Content-Type" => "application/json", "Accept" => "text/plain" }

  def self.political(test_text, api="remote")
    api_handler('text', test_text, api, "political")
  end

  def self.posneg(test_text, api="remote")
    api_handler('text', test_text, api, "sentiment")
  end

  def self.sentiment(*args)
    self.posneg(*args)
  end

  def self.language(test_text, api="remote")
    api_handler('text', test_text, api, "language")
  end

  def self.fer(face, api="remote")
    api_handler('face', face, api, "fer")
  end

  def self.facial_features(face, api="remote")
    api_handler('face', face, api, "facialfeatures")['response']
  end

end
