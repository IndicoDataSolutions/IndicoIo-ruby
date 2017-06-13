require 'indico/version'
require 'indico/helper'
require 'indico/image'
require 'indico/pdf'
require 'indico/multi'
require 'indico/settings'
require 'indico/errors'
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
    if !config
      config = {}
    end
    if !config.key?(:v) and !config.key?(:version)
      config['version'] = "2"
    end
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

  def self.personas(text, config = {})
    config['persona'] = true
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

  def self.emotion(text, config = nil)
    api_handler(text, 'emotion', config)
  end

  def self.text_tags(text, config = nil)
    api_handler(text, 'texttags', config)
  end

  def self.keywords(text, config = nil)
    if !config
      config = {}
    end
    if !config.key?(:v) and !config.key?(:version)
      config['version'] = "2"
    end
    if config.key?(:language) and config[:language] != "english"
      config['version'] = "1"
    end
    api_handler(text, 'keywords', config)

  end

  def self.relevance(text, queries, config = nil)
    if config.nil?
      config = Hash.new()
    end
    config[:queries] = queries
    config[:synonyms] = false
    return api_handler(text, 'relevance', config)
  end

  def self.text_features(text, config = nil)
    if config.nil?
      config = Hash.new()
    end
    config[:synonyms] = false
    return api_handler(text, 'textfeatures', config)
  end

  def self.people(text, config = {})
    if not (config.key?('v') or config.key?('version'))
      config['version'] = "2"
    end
    api_handler(text, "people", config)
  end

  def self.organizations(text, config = {})
    if not (config.key?('v') or config.key?('version'))
      config['version'] = "2"
    end
    api_handler(text, "organizations", config)
  end

  def self.places(text, config = {})
    if not (config.key?('v') or config.key?('version'))
      config['version'] = "2"
    end
    api_handler(text, "places", config)
  end

  def self.summarization(text, config = {})
    api_handler(text, "summarization", config)
  end

  def self.pdf_extraction(pdf, config = {})
    api_handler(preprocess_pdf(pdf), "pdfextraction", config)
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
    unless config.key?('v') or config.key?('version')
      config['version'] = "3"
    end
    api_handler(preprocess(image, 512, true), 'imagefeatures', config)
  end

  def self.image_recognition(image, config = nil)
    api_handler(preprocess(image, 144, true), 'imagerecognition', config)
  end


  def self.content_filtering(image, config = nil)
    api_handler(preprocess(image, 128, true), 'contentfiltering', config)
  end

  def self.analyze_image(face, apis = IMAGE_APIS, config = nil)
    api_hash = {'apis' => apis}
    multi(preprocess(face, 48, false), "image", apis, IMAGE_APIS, config ? config.update(api_hash) : api_hash)
  end

  def self.analyze_text(text, apis = TEXT_APIS, config = nil)
    api_hash = {'apis' => apis}
    multi(text, "text", apis, TEXT_APIS, config ? config.update(api_hash) : api_hash)
  end

  def self.collections(config = nil)
    Indico.api_handler(nil, 'custom', config, 'collections')
  end

  class Collection

      def initialize(collection, config = nil)
        if collection.kind_of?(String)
          @keywords = {
            "shared" => config.nil? ? nil : config["shared"],
            "domain" => config.nil? ? nil : config["domain"],
            "collection" => collection
          }

        else
          raise TypeError, "Collection must be initialized with a String name"
        end
      end

      def _api_handler(data, api, config = nil, method = 'predict')
        if config.nil?
          config = Hash.new()
        end
        config = @keywords.merge(config)
        Indico.api_handler(data, api, config, method)
      end

      def add_data(data, config = nil)

        is_batch = data[0].kind_of?(Array)
        if is_batch
          x, y = data.transpose
          x = Indico::preprocess(x, 512, true)
          data = x.zip(y)
        else
          data[0] = Indico::preprocess(data[0], 512, true)
        end
        _api_handler(data, 'custom', config, 'add_data')
      end

      def train(config = nil)
        _api_handler(nil, 'custom', config, 'train')
      end

      def wait(interval = 1)
        while true do
          status = info()['status']
          if status == "ready"
            break
          elsif status != "training"
            raise IndicoError, "Collection training ended with failure: " + status
            break
          end
          sleep(interval)
        end
      end

      def info(config = nil)
        _api_handler(nil, 'custom', config, 'info')
      end

      def predict(data, config = nil)
        data = Indico::preprocess(data, 512, true)
        _api_handler(data, 'custom', config, 'predict')
      end

      def remove_example(data, config = nil)
        data = Indico::preprocess(data, 512, true)
        _api_handler(data, 'custom', config, 'remove_example')
      end

      def clear(config = nil)
        _api_handler(nil, 'custom', config, 'clear_collection')
      end

      def rename(name, config = nil)
        if config.nil?
          config = Hash.new()
        end
        config[:name] = name
        result = _api_handler(nil, 'custom', config, 'rename')
        @keywords['collection'] = name
        return result
      end

      def register(config = nil)
        _api_handler(nil, 'custom', config, 'register')
      end

      def deregister(config = nil)
        _api_handler(nil, 'custom', config, 'deregister')
      end

      def authorize(email, permission_type = 'read', config = nil)
        if config.nil?
          config = Hash.new()
        end
        config[:email] = email
        config[:permission_type] = permission_type
        _api_handler(nil, 'custom', config, 'authorize')
      end

      def deauthorize(email, config = nil)
        if config.nil?
          config = Hash.new()
        end
        config[:email] = email
        _api_handler(nil, 'custom', config, 'deauthorize')
      end
  end
end
