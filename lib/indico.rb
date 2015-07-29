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

  def self.posneg(*args)
    sentiment(*args)
  end

  def self.sentiment(text, config = nil)
    api_handler(text, 'sentiment', config)
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


  def self.language(text, config = nil)
    api_handler(text, 'language', config)
  end


  def self.text_tags(text, config = nil)
    api_handler(text, 'texttags', config)
  end


  def self.keywords(text, config = nil)
    api_handler(text, 'keywords', config)
  end


  def self.named_entities(test_text, config = nil)
    api_handler(test_text, 'namedentities', config)
  end


  def self.fer(test_image, config = nil)
    size = (config != nil and config["detect"] == true) ? false : 48
    api_handler(preprocess(test_image, 48, false), 'fer', config)
  end


  def self.facial_features(image, config = nil)
    api_handler(preprocess(image, 48), 'facialfeatures', config)
  end


  def self.image_features(image, config = nil)
    api_handler(preprocess(image, 64), 'imagefeatures', config)
  end


  def self.content_filtering(image, config = nil)
    api_handler(preprocess(image, 128), 'contentfiltering', config)
  end


  def self.predict_image(face, apis = IMAGE_APIS, config = nil)
    api_hash = {apis:apis}
    multi(preprocess(face, 48), "image", apis, IMAGE_APIS, config ? config.update(api_hash) : api_hash)
  end

  # FIXME - use settings TEXT_APIS when sentimenthq is released
  def self.predict_text(text, apis = ['political', 'sentiment', 'language', 'text_tags'], config = nil)
    api_hash = {apis:apis}
    multi(text, "text", apis, TEXT_APIS, config ? config.update(api_hash) : api_hash)
  end

end
