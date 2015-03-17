require "indico/version"
require "indico/helper"
require "uri"
require "json"
require "net/https"

module Indico

  HEADERS = { "Content-Type" => "application/json", "Accept" => "text/plain" }

  def self.political(test_text, api="remote")
    api_handler(test_text, api, "political")
  end

  def self.batch_political(test_text, username, password, api="remote")
    api_handler(test_text, api, "political/batch", username, password)
  end

  def self.posneg(test_text, api="remote")
    api_handler(test_text, api, "sentiment")
  end

  def self.batch_posneg(test_text, username, password, api="remote")
    api_handler(test_text, api, "sentiment/batch", username, password)
  end

  def self.sentiment(*args)
    self.posneg(*args)
  end

  def self.batch_sentiment(*args)
    self.batch_posneg(*args)
  end

  def self.language(test_text, api="remote")
    api_handler(test_text, api, "language")
  end

  def self.batch_language(test_text, username, password, api="remote")
    api_handler(test_text, api, "language/batch", username, password)
  end

  def self.text_tags(test_text, api="remote")
    api_handler(test_text, api, "texttags")
  end

  def self.batch_text_tags(test_text, username, password, api="remote")
    api_handler(test_text, api, "texttags/batch", username, password)
  end

  def self.fer(face, api="remote")
    api_handler(face, api, "fer")
  end

  def self.batch_fer(test_text, username, password, api="remote")
    api_handler(test_text, api, "fer/batch", username, password)
  end

  def self.facial_features(face, api="remote")
    api_handler(face, api, "facialfeatures")
  end

  def self.batch_facial_features(test_text, username, password, api="remote")
    api_handler(test_text, api, "facialfeatures/batch", username, password)
  end

  def self.image_features(face, api="remote")
    api_handler(face, api, "imagefeatures")
  end

  def self.batch_image_features(test_text, username, password, api="remote")
    api_handler(test_text, api, "imagefeatures/batch", username, password)
  end

end
