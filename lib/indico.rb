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

  def self.political(text, config = nil)
    api_handler(text, 'political', config)
  end

  def self.batch_political(text, config = nil)
    api_handler(text, 'political/batch', config)
  end

  def self.posneg(*args)
    sentiment(*args)
  end

  def self.batch_posneg(*args)
    batch_sentiment(*args)
  end

  def self.sentiment(text, config = nil)
    api_handler(text, 'sentiment', config)
  end

  def self.batch_sentiment(text, config = nil)
    api_handler(text, 'sentiment/batch', config)
  end

  def self.twitter_engagement(text, config = nil)
    api_handler(text, 'twitterengagement', config)
  end

  def self.batch_twitter_engagement(text, config = nil)
    api_handler(text, 'twitterengagement/batch', config)
  end

  def self.sentiment_hq(text, config = nil)
    api_handler(text, 'sentimenthq', config)
  end

  def self.batch_sentiment_hq(text, config = nil)
    api_handler(text, 'sentimenthq/batch', config)
  end

  def self.language(text, config = nil)
    api_handler(text, 'language', config)
  end

  def self.batch_language(text, config = nil)
    api_handler(text, 'language/batch', config)
  end

  def self.text_tags(text, config = nil)
    api_handler(text, 'texttags', config)
  end

  def self.batch_text_tags(text, config = nil)
    api_handler(text, 'texttags/batch', config)
  end

  def self.keywords(text, config = nil)
    api_handler(text, 'keywords', config)
  end

  def self.batch_keywords(text, config = nil)
    api_handler(text, 'keywords/batch', config)
  end

  def self.named_entities(test_text, config = nil)
    api_handler(test_text, 'namedentities', config)
  end

  def self.batch_named_entities(test_text, config = nil)
    api_handler(test_text, 'namedentities/batch', config)
  end

  def self.fer(test_image, config = nil)
    should_resize = !config.nil? and (config.key?(:detect) and config[:detect])
    api_handler(preprocess(test_image, 48, false, should_resize), 'fer', config)
  end

  def self.batch_fer(image, config = nil)
    api_handler(preprocess(image, 48, true), 'fer/batch', config)
  end

  def self.facial_features(image, config = nil)
    api_handler(preprocess(image, 48, false), 'facialfeatures', config)
  end

  def self.batch_facial_features(image, config = nil)
    api_handler(preprocess(image, 48, true), 'facialfeatures/batch', config)
  end

  def self.image_features(image, config = nil)
    api_handler(preprocess(image, 64, false), 'imagefeatures', config)
  end

  def self.batch_image_features(image, config = nil)
    api_handler(preprocess(image, 64, true), 'imagefeatures/batch', config)
  end

  def self.content_filtering(image, config = nil)
    api_handler(preprocess(image, 128, false, false), 'contentfiltering', config)
  end

  def self.batch_content_filtering(image, config = nil)
    api_handler(preprocess(image, 128, true, false), 'contentfiltering/batch', config)
  end

  def self.predict_image(face, apis = IMAGE_APIS, config = nil)
    api_hash = {apis:apis}
    multi(preprocess(face, 48, false), "image", apis, IMAGE_APIS, config ? config.update(api_hash) : api_hash)
  end

  # FIXME - use settings TEXT_APIS when sentimenthq is released
  def self.predict_text(text, apis = ['political', 'sentiment', 'language', 'text_tags'], config = nil)
    api_hash = {apis:apis}
    multi(text, "text", apis, TEXT_APIS, config ? config.update(api_hash) : api_hash)
  end

  def self.batch_predict_image(face, apis, config = nil)
    api_hash = {apis:apis}
    multi(preprocess(face, 48, true), "image", apis, IMAGE_APIS, true, config ? config.update(api_hash) : api_hash)
  end

  # FIXME - use settings TEXT_APIS when sentimenthq is released
  def self.batch_predict_text(text, apis = ['political', 'sentiment', 'language', 'text_tags'], config = nil)
    api_hash = {apis:apis}
    multi(text, "text", apis, TEXT_APIS, true, config ? config.update(api_hash) : api_hash)
  end
end
