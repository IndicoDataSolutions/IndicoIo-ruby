require 'indico/version'
require 'indico/helper'
require 'indico/image'
require 'indico/multi'
require 'indico/settings'
require 'uri'
require 'json'
require 'net/https'

module Indico
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
    api_handler(test_text, 'political', config)
  end

  def self.batch_political(test_text, config = nil)
    api_handler(test_text, 'political/batch', config)
  end

  def self.posneg(*args)
    sentiment(*args)
  end

  def self.batch_posneg(*args)
    batch_sentiment(*args)
  end

  def self.sentiment(test_text, config = nil)
    api_handler(test_text, 'sentiment', config)
  end

  def self.batch_sentiment(test_text, config = nil)
    api_handler(test_text, 'sentiment/batch', config)
  end

  def self.sentiment_hq(test_text, config = nil)
    api_handler(test_text, 'sentimenthq', config)
  end

  def self.batch_sentiment_hq(test_text, config = nil)
    api_handler(test_text, 'sentimenthq/batch', config)
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

  def self.fer(test_image, config = nil)
    api_handler(preprocess(test_image, 48, false), 'fer', config)
  end

  def self.batch_fer(test_image, config = nil)
    api_handler(preprocess(test_image, 48, true), 'fer/batch', config)
  end

  def self.facial_features(test_image, config = nil)
    api_handler(preprocess(test_image, 48, false), 'facialfeatures', config)
  end

  def self.batch_facial_features(test_image, config = nil)
    api_handler(preprocess(test_image, 48, true), 'facialfeatures/batch', config)
  end

  def self.image_features(test_image, config = nil)
    api_handler(preprocess(test_image, 64, false), 'imagefeatures', config)
  end

  def self.batch_image_features(test_image, config = nil)
    api_handler(preprocess(test_image, 64, true), 'imagefeatures/batch', config)
  end

  def self.predict_image(face, apis = IMAGE_APIS, config = nil)
    api_hash = {apis:apis}
    multi(preprocess(face, 48, false), "image", apis, IMAGE_APIS, config ? config.update(api_hash) : api_hash)
  end

  # FIXME - use settings TEXT_APIS when sentimenthq is released
  def self.predict_text(test_text, apis = ['political', 'sentiment', 'language', 'text_tags'], config = nil)
    api_hash = {apis:apis}
    multi(test_text, "text", apis, TEXT_APIS, config ? config.update(api_hash) : api_hash)
  end

  def self.batch_predict_image(face, apis, config = nil)
    api_hash = {apis:apis}
    multi(preprocess(face, 48, true), "image", apis, IMAGE_APIS, true, config ? config.update(api_hash) : api_hash)
  end

  # FIXME - use settings TEXT_APIS when sentimenthq is released
  def self.batch_predict_text(test_text, apis = ['political', 'sentiment', 'language', 'text_tags'], config = nil)
    api_hash = {apis:apis}
    multi(test_text, "text", apis, TEXT_APIS, true, config ? config.update(api_hash) : api_hash)
  end
end
