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

  def self.personality(text, config = nil)
    api_handler(text, 'personality', config)
  end

  def self.personas(text, config = {'persona'=> true})
    api_handler(text, 'personality', config)
  end

  def self.twitter_engagement(text, config = nil)
    api_handler(text, 'twitterengagement', config)
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

  def self.relevance(text, queries, config = nil)
    if config.nil?
      config = Hash.new()
    end
    config[:queries] = queries
    return api_handler(text, 'relevance', config)
  end

  def self.people(text, config = nil)
    api_handler(text, "people", config)
  end

  def self.organizations(text, config = nil)
    api_handler(text, "organizations", config)
  end

  def self.places(text, config = nil)
    api_handler(text, "places", config)
  end

  def self.fer(image, config = nil)
    size = (config != nil and config["detect"] == true) ? false : 48
    api_handler(preprocess(image, size, false), 'fer', config)
  end

  def self.facial_features(image, config = nil)
    api_handler(preprocess(image, 48, false), 'facialfeatures', config)
  end

  def self.facial_localization(image, config = nil)
    api_handler(preprocess(image, false, false), 'faciallocalization', config)
  end

  def self.image_features(image, config = {})
    unless config.key?(:v) or config.key?(:version)
      config[:version] = "3"
    end
    api_handler(preprocess(image, 144, true), 'imagefeatures', config)
  end

  def self.image_recognition(image, config = nil)
    api_handler(preprocess(image, 144, true), 'imagerecognition', config)
  end


  def self.content_filtering(image, config = nil)
    api_handler(preprocess(image, 128, true), 'contentfiltering', config)
  end

  def self.analyze_image(face, apis = IMAGE_APIS, config = nil)
    api_hash = {apis:apis}
    multi(preprocess(face, 48, false), "image", apis, IMAGE_APIS, config ? config.update(api_hash) : api_hash)
  end

  def self.analyze_text(text, apis = TEXT_APIS, config = nil)
    api_hash = {apis:apis}
    multi(text, "text", apis, TEXT_APIS, config ? config.update(api_hash) : api_hash)
  end

  def self.collections(config = nil)
    Indico.api_handler(nil, 'custom', config, 'collections')
  end

  class Collection

      def initialize(collection)
        if collection.kind_of?(String)
          @collection = collection
        else
          raise TypeError, "Collection must be initialized with a String name"
        end
      end

      def add_data(data, config = nil)

        is_batch = data[0].kind_of?(Array)
        if is_batch
          x, y = data.transpose
          x = Indico::preprocess(x, 144, true)
          data = x.zip(y)
        else
          data[0] = Indico::preprocess(data[0], 144, true)
        end

        if config.nil?
          config = Hash.new()
        end
        config[:collection] = @collection
        Indico.api_handler(data, 'custom', config, 'add_data')
      end

      def train(config = nil)
        if config.nil?
          config = Hash.new()
        end
        config[:collection] = @collection
        Indico.api_handler(nil, 'custom', config, 'train')
      end

      def wait(interval = 1)
        while info()['status'] != "ready" do
          sleep(interval)
        end
      end

      def info(interval = 1)
        Indico.collections()[@collection]
      end

      def predict(data, config = nil)
        data = Indico::preprocess(data, 144, true)
        if config.nil?
          config = Hash.new()
        end
        config[:collection] = @collection
        Indico.api_handler(data, 'custom', config, 'predict')
      end

      def remove_example(data, config = nil)
        data = Indico::preprocess(data, 144, true)
        if config.nil?
          config = Hash.new()
        end
        config[:collection] = @collection
        Indico.api_handler(data, 'custom', config, 'remove_example')
      end

      def clear(config = nil)
        if config.nil?
          config = Hash.new()
        end
        config[:collection] = @collection
        Indico.api_handler(nil, 'custom', config, 'clear_collection')
      end
  end
end
