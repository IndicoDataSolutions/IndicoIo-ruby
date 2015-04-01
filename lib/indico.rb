require 'indico/version'
require 'indico/helper'
require 'indico/settings'
require 'uri'
require 'json'
require 'net/https'

module Indico
  HEADERS = { 'Content-Type' => 'application/json', 'Accept' => 'text/plain' }

  def self.political(test_text, api_key=nil,
                     private_cloud = nil)
    api_handler(test_text, private_cloud, 'political', api_key)
  end

  def self.batch_political(test_text, api_key=nil, private_cloud = nil)
    api_handler(test_text, private_cloud, 'political/batch', api_key)
  end

  def self.posneg(test_text, api_key=nil,
                  private_cloud = nil)
    api_handler(test_text, private_cloud, 'sentiment', api_key)
  end

  def self.batch_posneg(test_text, api_key=nil, private_cloud = nil)
    api_handler(test_text, private_cloud, 'sentiment/batch', api_key)
  end

  def self.sentiment(*args)
    posneg(*args)
  end

  def self.batch_sentiment(*args)
    batch_posneg(*args)
  end

  def self.language(test_text, api_key=nil,
                    private_cloud = nil)
    api_handler(test_text, private_cloud, 'language', api_key)
  end

  def self.batch_language(test_text, api_key=nil, private_cloud = nil)
    api_handler(test_text, private_cloud, 'language/batch', api_key)
  end

  def self.text_tags(test_text, api_key=nil,
                     private_cloud = nil)
    api_handler(test_text, private_cloud, 'texttags', api_key)
  end

  def self.batch_text_tags(test_text, api_key=nil, private_cloud = nil)
    api_handler(test_text, private_cloud, 'texttags/batch', api_key)
  end

  def self.fer(face, api_key=nil, private_cloud = nil)
    api_handler(face, private_cloud, 'fer', api_key)
  end

  def self.batch_fer(test_text, api_key=nil, private_cloud = nil)
    api_handler(test_text, private_cloud, 'fer/batch', api_key)
  end

  def self.facial_features(face, api_key=nil,
                           private_cloud = nil)
    api_handler(face, private_cloud, 'facialfeatures', api_key)
  end

  def self.batch_facial_features(test_text, api_key=nil,
                                 private_cloud = nil)
    api_handler(test_text, private_cloud, 'facialfeatures/batch',
                api_key)
  end

  def self.image_features(face, api_key=nil,
                          private_cloud = nil)
    api_handler(face, private_cloud, 'imagefeatures', api_key)
  end

  def self.batch_image_features(test_text, api_key=nil,
                                private_cloud = nil)
    api_handler(test_text, private_cloud, 'imagefeatures/batch',
                api_key)
  end
end
