require 'indico/version'
require 'indico/helper'
require 'indico/settings'
require 'uri'
require 'json'
require 'net/https'

module Indico
  HEADERS = { 'Content-Type' => 'application/json', 'Accept' => 'text/plain' }

  def self.api_key
    config['auth']
  end

  def self.api_key=(api)
    config['auth'] = api
  end

  def self.private_cloud
    config['cloud']
  end

  def self.private_cloud=(cloud)
    config['cloud'] = cloud
  end

  def self.political(test_text, config = nil)
    api_handler(test_text, 'political', 'config')
  end

  def self.batch_political(test_text, config = nil)
    api_handler(test_text, 'political/batch', config)
  end

  def self.posneg(test_text, config = nil)
    api_handler(test_text, 'sentiment', config)
  end

  def self.batch_posneg(test_text, config = nil)
    api_handler(test_text, 'sentiment/batch', config)
  end

  def self.sentiment(*args)
    posneg(*args)
  end

  def self.batch_sentiment(*args)
    batch_posneg(*args)
  end

  def self.language(test_text, config = nil)
    api_handler(test_text, 'language', config)
  end

  def self.batch_language(test_text, config = nil)
    api_handler(test_text, 'language/batch', config)
  end

  def self.text_tags(test_text, config = nil)
    api_handler(test_text, 'texttags', config)
  end

  def self.batch_text_tags(test_text, config = nil)
    api_handler(test_text, 'texttags/batch', config)
  end

  def self.fer(face, config = nil)
    api_handler(face, 'fer', config)
  end

  def self.batch_fer(test_text, config = nil)
    api_handler(test_text, 'fer/batch', config)
  end

  def self.facial_features(face, config = nil)
    api_handler(face, 'facialfeatures', config)
  end

  def self.batch_facial_features(test_text, config = nil)
    api_handler(test_text, 'facialfeatures/batch', config)
  end

  def self.image_features(face, config = nil)
    api_handler(face, 'imagefeatures', config)
  end

  def self.batch_image_features(test_text, config = nil)
    api_handler(test_text, 'imagefeatures/batch', config)
  end
end
