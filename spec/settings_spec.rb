require 'spec_helper'

describe Indico do
    it "should correctly parse an ini file" do 
        Indico.load_config_files(['/home/mmay/.indicorc', './.indicorc'])
    end

    it "should find the correct config files" do 
        files = Indico.find_config_files()
        expect(files[0]).to eql("#{Dir.home}/.indicorc")
        expect(files[1]).to eql("#{Dir.pwd}/.indicorc")
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
end
