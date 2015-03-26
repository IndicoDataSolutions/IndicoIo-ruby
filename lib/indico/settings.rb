require 'inifile'

module Indico
  private

  class << self; attr_accessor :config; end

  def self.merge_config(prev_config, new_config)
    validAuth = new_config['auth'] && 
                new_config['auth']['username'] && 
                new_config['auth']['password']

    if validAuth
      prev_config['auth'] = [
        new_config['auth']['username'], new_config['auth']['password']
      ]
    end

    validCloud = new_config['private_cloud'] &&
                 new_config['private_cloud']['cloud']

    if validCloud
      prev_config['cloud'] = new_config['private_cloud']['cloud']
    end
    return prev_config
  end

  def self.load_config_files(filenames)
    # Given a list of filenames, build up an ini file config
    master_ini = Hash.new
    master_ini['auth'] = false
    master_ini['cloud'] = false

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
    # returns the paths to the pertinent config files
    localPath = File.join(Dir.pwd, ".indicorc")
    globalPath = File.join(Dir.home, ".indicorc")
    return [globalPath, localPath]
  end

  def self.load_environment_vars()
    config = Hash.new
    config['auth'] = Hash.new
    config['auth']['username'] = ENV["INDICO_USERNAME"]
    config['auth']['password'] = ENV["INDICO_PASSWORD"]
    config['private_cloud'] = Hash.new
    config['private_cloud']['cloud'] = ENV["INDICO_CLOUD"]
    return config
  end

  def self.load_config()
    paths = self.find_config_files()
    config_file = self.load_config_files(paths)
    env_vars = self.load_environment_vars()
    config = self.merge_config(config_file, env_vars)
    return config
  end
end

Indico.config = Indico.load_config()
