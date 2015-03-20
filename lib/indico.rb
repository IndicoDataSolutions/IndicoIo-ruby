require "indico/version"
require "indico/helper"
require "uri"
require "json"
require "net/https"

module Indico

  HEADERS = { "Content-Type" => "application/json", "Accept" => "text/plain" }

  def self.political(test_text, username=nil, password=nil, private_cloud=nil)
    api_handler(test_text, private_cloud, "political", username, password)
  end

  def self.batch_political(test_text, username, password, private_cloud=nil)
    api_handler(test_text, private_cloud, "political/batch", username, password)
  end

  def self.posneg(test_text, username=nil, password=nil, private_cloud=nil)
    api_handler(test_text, private_cloud, "sentiment", username, password)
  end

  def self.batch_posneg(test_text, username, password, private_cloud=nil)
    api_handler(test_text, private_cloud, "sentiment/batch", username, password)
  end

  def self.sentiment(*args)
    self.posneg(*args)
  end

  def self.batch_sentiment(*args)
    self.batch_posneg(*args)
  end

  def self.language(test_text, username=nil, password=nil, private_cloud=nil)
    api_handler(test_text, private_cloud, "language", username, password)
  end

  def self.batch_language(test_text, username, password, private_cloud=nil)
    api_handler(test_text, private_cloud, "language/batch", username, password)
  end

  def self.text_tags(test_text, username=nil, password=nil, private_cloud=nil)
    api_handler(test_text, private_cloud, "texttags", username, password)
  end

  def self.batch_text_tags(test_text, username, password, private_cloud=nil)
    api_handler(test_text, private_cloud, "texttags/batch", username, password)
  end

  def self.fer(face, username=nil, password=nil, private_cloud=nil)
    api_handler(face, private_cloud, "fer", username, password)
  end

  def self.batch_fer(test_text, username, password, private_cloud=nil)
    api_handler(test_text, private_cloud, "fer/batch", username, password)
  end

  def self.facial_features(face, username=nil, password=nil, private_cloud=nil)
    api_handler(face, private_cloud, "facialfeatures", username, password)
  end

  def self.batch_facial_features(test_text, username, password, private_cloud=nil)
    api_handler(test_text, private_cloud, "facialfeatures/batch", username, password)
  end

  def self.image_features(face, username=nil, password=nil, private_cloud=nil)
    api_handler(face, private_cloud, "imagefeatures", username, password)
  end

  def self.batch_image_features(test_text, username, password, private_cloud=nil)
    api_handler(test_text, private_cloud, "imagefeatures/batch", username, password)
  end

end
