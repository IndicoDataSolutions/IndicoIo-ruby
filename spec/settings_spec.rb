require 'spec_helper'

describe Indico do
    it "should correctly parse an ini file without raising an error" do 
        Indico.load_config_files(Indico.find_config_files())
    end

    it "should find the correct config files" do 
        files = Indico.find_config_files()
        expect(files[0]).to eql("#{Dir.home}/.indicorc")
        expect(files[1]).to eql("#{Dir.pwd}/.indicorc")
    end

    it "should read in config files properly" do 
        files = [
            File.expand_path("../config/.indicorc.test", __FILE__),
            File.expand_path("../config/.indicorc.test.2", __FILE__)
        ]
        config = Indico.load_config_files(files)
        expected_auth = Hash.new
        expected_auth['username'] = "test2@example.com"
        expected_auth['password'] = "test2"
        expect(config["auth"]).to eql(expected_auth)
    end

    it "should read in variables from the user's environment" do 
        username = "username"
        password = "password"
        cloud = "cloud"
        ENV['INDICO_USERNAME'] = username
        ENV['INDICO_PASSWORD'] = password
        ENV['INDICO_CLOUD'] = cloud

        config = Indico.load_environment_vars()
        expected_auth = Hash.new
        expected_auth['username'] = username
        expected_auth['password'] = password

        expected_cloud = Hash.new
        expected_cloud['cloud'] = cloud

        expect(config["auth"]).to eql(expected_auth)
        expect(config["private_cloud"]).to eql(expected_cloud)
    end

    it "should combine file and env variable configuration" do
        username = "username"
        password = "password"
        cloud = "cloud"
        ENV['INDICO_USERNAME'] = username
        ENV['INDICO_PASSWORD'] = password
        ENV['INDICO_CLOUD'] = cloud

        expected = Hash.new
        expected['auth'] = [username, password]
        expected['cloud'] = cloud

        config = Indico.load_config()
        expect(config).to eql(expected)
    end

    it "should merge configurations properly" do 

        file_username = "file-username"
        file_password = "file-password"
        file_cloud = "file-cloud"
        file_config = Hash.new
        file_config['auth'] = Hash.new
        file_config['private_cloud'] = Hash.new
        file_config['auth']['username'] = file_username
        file_config['auth']['password'] = file_password
        file_config['private_cloud']['cloud'] = file_cloud

        env_username = "env-username"
        env_password = "env-password"
        env_cloud = "env-cloud"
        ENV['INDICO_USERNAME'] = env_username
        ENV['INDICO_PASSWORD'] = env_password
        ENV['INDICO_CLOUD'] = env_cloud

        env_config = Indico.load_environment_vars()
        merged = Indico.merge_config(file_config, env_config)
        expect(merged['auth']['username']).to eql(env_username)
        expect(merged['auth']['password']).to eql(env_password)
        expect(merged['private_cloud']['cloud']).to eql(env_cloud)
    end
end
