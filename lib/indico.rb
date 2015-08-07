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
    warn(
      "The `batch_political` function will be deprecated in the next major upgrade. " + 
      "Please call `political` instead with the same arguments"
    )
    self.political(text, config)
  end

  def self.posneg(*args)
    sentiment(*args)
  end

  def self.batch_posneg(text, config = nil)
    warn(
      "The `batch_posneg` function will be deprecated in the next major upgrade. " + 
      "Please call `posneg` instead with the same arguments"
    )
    self.posneg(text, config)
  end

  def self.sentiment(text, config = nil)
    api_handler(text, 'sentiment', config)
  end

  def self.batch_sentiment(text, config = nil)
    warn(
      "The `batch_sentiment` function will be deprecated in the next major upgrade. " + 
      "Please call `sentiment` instead with the same arguments"
    )
    self.sentiment(text, config)
  end


  def self.twitter_engagement(text, config = nil)
    api_handler(text, 'twitterengagement', config)
  end

  def self.batch_twitter_engagement(text, config = nil)
    warn(
      "The `batch_twitter_engagement` function will be deprecated in the next major upgrade. " + 
      "Please call `twitter_engagement` instead with the same arguments"
    )
    self.twitter_engagement(text, config)
  end

  def self.sentiment_hq(text, config = nil)
    api_handler(text, 'sentimenthq', config)
  end

  def self.batch_sentiment_hq(text, config = nil)
    warn(
      "The `batch_sentiment_hq` function will be deprecated in the next major upgrade. " + 
      "Please call `sentiment_hq` instead with the same arguments"
    )
    self.sentiment_hq(text, config)
  end


  def self.language(text, config = nil)
    api_handler(text, 'language', config)
  end

  def self.batch_language(text, config = nil)
    warn(
      "The `batch_language` function will be deprecated in the next major upgrade. " + 
      "Please call `language` instead with the same arguments"
    )
    self.language(text, config)
  end


  def self.text_tags(text, config = nil)
    api_handler(text, 'texttags', config)
  end

  def self.batch_text_tags(text, config = nil)
    warn(
      "The `batch_text_tags` function will be deprecated in the next major upgrade. " + 
      "Please call `text_tags` instead with the same arguments"
    )
    self.text_tags(text, config)
  end


  def self.keywords(text, config = nil)
    api_handler(text, 'keywords', config)
  end

  def self.batch_keywords(text, config = nil)
    warn(
      "The `batch_keywords` function will be deprecated in the next major upgrade. " + 
      "Please call `keywords` instead with the same arguments"
    )
    self.keywords(text, config)
  end


  def self.named_entities(test_text, config = nil)
    api_handler(test_text, 'namedentities', config)
  end

  def self.batch_named_entities(text, config = nil)
    warn(
      "The `batch_named_entities` function will be deprecated in the next major upgrade. " + 
      "Please call `named_entities` instead with the same arguments"
    )
    self.named_entities(text, config)
  end

  def self.fer(image, config = nil)
    size = (config != nil and config["detect"] == true) ? false : 48
    api_handler(preprocess(image, size, false), 'fer', config)
  end

  def self.batch_fer(image, config = nil)
    warn(
      "The `batch_fer` function will be deprecated in the next major upgrade. " + 
      "Please call `fer` instead with the same arguments"
    )
    self.fer(image, config)
  end


  def self.facial_features(image, config = nil)
    api_handler(preprocess(image, 48, false), 'facialfeatures', config)
  end

  def self.batch_facial_features(image, config = nil)
    warn(
      "The `batch_facial_features` function will be deprecated in the next major upgrade. " + 
      "Please call `facial_features` instead with the same arguments"
    )
    self.facial_features(image, config)
  end

  def self.facial_localization(image, config = nil)
    api_handler(preprocess(image, 128, false), 'faciallocalization', config)
  end

  def self.batch_facial_localization(image, config = nil)
    warn(
      "The `batch_facial_localization` function will be deprecated in the next major upgrade. " + 
      "Please call `facial_localization` instead with the same arguments"
    )
    self.facial_localization(image, config)
  end

  def self.image_features(image, config = nil)
    api_handler(preprocess(image, 64, false), 'imagefeatures', config)
  end

  def self.batch_image_features(image, config = nil)
    warn(
      "The `batch_image_features` function will be deprecated in the next major upgrade. " + 
      "Please call `image_features` instead with the same arguments"
    )
    self.image_features(image, config)
  end

  def self.content_filtering(image, config = nil)
    api_handler(preprocess(image, 128, true), 'contentfiltering', config)
  end

  def self.batch_content_filtering(image, config = nil)
    warn(
      "The `batch_content_filtering` function will be deprecated in the next major upgrade. " + 
      "Please call `content_filtering` instead with the same arguments"
    )
    self.content_filtering(image, config)
  end

  def self.predict_image(face, apis = IMAGE_APIS, config = nil)
    api_hash = {apis:apis}
    multi(preprocess(face, 48, false), "image", apis, IMAGE_APIS, config ? config.update(api_hash) : api_hash)
  end

  def self.batch_predict_image(image, config = nil)
    warn(
      "The `batch_predict_image` function will be deprecated in the next major upgrade. " + 
      "Please call `predict_image` instead with the same arguments"
    )
    self.predict_image(image, config)
  end

  def self.predict_text(text, apis = TEXT_APIS, config = nil)
    api_hash = {apis:apis}
    multi(text, "text", apis, TEXT_APIS, config ? config.update(api_hash) : api_hash)
  end

  def self.batch_predict_text(text, config = nil)
    warn(
      "The `batch_predict_text` function will be deprecated in the next major upgrade. " + 
      "Please call `predict_text` instead with the same arguments"
    )
    self.predict_text(text, config)
  end

end
