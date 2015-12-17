require 'inifile'
require_relative 'version'

HEADERS = { 'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'client-lib' => 'ruby',
            'version-number' => Indico::VERSION }
# APIS
TEXT_APIS = [
  "political",
  "sentiment",
  "sentiment_hq",
  "language", 
  "text_tags",
  "twitter_engagement",
  "keywords",
  "named_entities",
  "people",
  "places",
  "organizations"
]
IMAGE_APIS = [
  "fer",
  "facial_features",
  "facial_localization",
  "image_features",
  "content_filtering"
]

MULTIAPI_NOT_SUPPORTED = [
  "relevance",
  "personas"
]
API_TYPES = {}
TEXT_APIS.each do |api|
  API_TYPES[:api] = 'text'
end
IMAGE_APIS.each do |api|
  API_TYPES[:api] = 'image'
end

module Indico
  private

  class << self; attr_accessor :config; end
  class << self; attr_accessor :cloud_protocol; end

  Indico.cloud_protocol = 'https://'

  def self.valid_auth(config)
    # Does a config hashmap have a valid auth definition?
    return config['auth'] &&
           config['auth']['api_key']
  end

  def self.valid_cloud(config)
    # Does a config hashmap have a valid private cloud definition?
    return config['private_cloud'] &&
           config['private_cloud']['cloud']
  end

  def self.merge_config(prev_config, new_config)
    # Merge two configurations, giving precedence to the second
    if self.valid_auth(new_config)
      prev_config['auth'] = new_config['auth']
    end

    if self.valid_cloud(new_config)
      prev_config['private_cloud'] = new_config['private_cloud']
    end

    return prev_config
  end

  def self.load_config_files(filenames)
    # Given a list of filenames, build up an ini file config
    master_ini = self.new_config()

    for filename in filenames
      ini = IniFile.load(filename)
      if not ini then
        next
      end
      master_ini = self.merge_config(master_ini, ini)
    end
    return master_ini
  end

  def self.find_config_files()
    # Provides a list of paths to search for indicorc files
    localPath = File.join(Dir.pwd, ".indicorc")
    globalPath = File.join(Dir.home, ".indicorc")
    return [globalPath, localPath]
  end

  def self.load_environment_vars()
    # Load environment variables into same format as INI file reader
    return {'auth' => {'api_key' => ENV["INDICO_API_KEY"]},
              'private_cloud' => {'cloud' => ENV["INDICO_CLOUD"]}}
  end

  def self.new_config()
    # Makes a new, empty config object
    new_config = Hash.new
    new_config['auth'] = false
    new_config['cloud'] = false
    return new_config
  end

  def self.simplify_config(config)
    # Goes from nested representation to flatter version
    new_config = self.new_config()
    if self.valid_auth(config)
      new_config['auth'] = config['auth']['api_key']
    end
    if self.valid_cloud(config)
      new_config['cloud'] = config['private_cloud']['cloud']
    end
    return new_config
  end

  def self.load_config()
    # Finds, loads, and simplifies all configuration types
    paths = self.find_config_files()
    config_file = self.load_config_files(paths)
    env_vars = self.load_environment_vars()
    config = self.merge_config(config_file, env_vars)
    return self.simplify_config(config)
  end
end

Indico.config = Indico.load_config()
