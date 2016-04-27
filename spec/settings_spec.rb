require 'spec_helper'

describe Indico do
    it 'should correctly parse an ini file without raising an error' do
        Indico.load_config_files(Indico.find_config_files())
    end

    it 'should find the correct config files' do
        files = Indico.find_config_files()
        expect(files[0]).to eql("#{Dir.home}/.indicorc")
        expect(files[1]).to eql("#{Dir.pwd}/.indicorc")
    end

    it 'should read in config files properly' do
        files = [
            File.expand_path('../config/.indicorc.test', __FILE__),
            File.expand_path('../config/.indicorc.test.2', __FILE__)
        ]
        config = Indico.load_config_files(files)
        expected_auth = Hash.new
        expected_auth['api_key'] = 'testapikey'
        expect(config['auth']).to eql(expected_auth)
    end

    it 'should read in variables from the user\'s environment' do
        api_key = 'testapikey'
        cloud = 'cloud'

        saved_api_key = ENV['INDICO_API_KEY']
        saved_private_cloud = ENV['INDICO_CLOUD']

        ENV['INDICO_API_KEY'] = api_key
        ENV['INDICO_CLOUD'] = cloud

        config = Indico.load_environment_vars()
        expected_auth = Hash.new
        expected_auth['api_key'] = 'testapikey'

        expected_cloud = Hash.new
        expected_cloud['cloud'] = cloud

        expect(config['auth']).to eql(expected_auth)
        expect(config['private_cloud']).to eql(expected_cloud)

        ENV['INDICO_API_KEY'] = saved_api_key
        ENV['INDICO_CLOUD'] = saved_private_cloud
    end

    it 'should combine file and env variable configuration' do
        api_key = 'testapikey'
        cloud = 'cloud'

        saved_api_key = ENV['INDICO_API_KEY']
        saved_private_cloud = ENV['INDICO_CLOUD']

        ENV['INDICO_API_KEY'] = api_key
        ENV['INDICO_CLOUD'] = cloud

        expected = Hash.new
        expected['auth'] = api_key
        expected['cloud'] = cloud

        config = Indico.load_config()
        expect(config).to eql(expected)

        ENV['INDICO_API_KEY'] = saved_api_key
        ENV['INDICO_CLOUD'] = saved_private_cloud
    end

    it 'should merge configurations properly' do

        file_api_key = 'file-api-key'
        file_cloud = 'file-cloud'
        file_config = Hash.new
        file_config['auth'] = Hash.new
        file_config['private_cloud'] = Hash.new
        file_config['auth']['api_key'] = file_api_key
        file_config['private_cloud']['cloud'] = file_cloud

        env_api_key = 'env-api-key'
        env_cloud = 'env-cloud'
        saved_api_key = ENV['INDICO_API_KEY'] 
        saved_private_cloud = ENV['INDICO_CLOUD'] 

        ENV['INDICO_API_KEY'] = env_api_key
        ENV['INDICO_CLOUD'] = env_cloud

        env_config = Indico.load_environment_vars()
        merged = Indico.merge_config(file_config, env_config)
        expect(merged['auth']['api_key']).to eql(env_api_key)
        expect(merged['private_cloud']['cloud']).to eql(env_cloud)

        ENV['INDICO_API_KEY'] = saved_api_key
        ENV['INDICO_CLOUD'] = saved_private_cloud 
    end

    it 'should set api key with a call to set_api_key' do
        saved_key = Indico.api_key
        Indico.api_key = nil
        begin
            Indico.political('Guns don\'t kill people. People kill people.')
        rescue ArgumentError => exception
            expect(exception.message).to eql('api key is required')
        else
            fail('api_key was not null')
        end

        begin
            Indico.political('Guns don\'t kill people. People kill people.')
        rescue ArgumentError => exception
            expect(exception.message).to eql('api key is required')
        else
            fail('api_key was not null')
        end
        Indico.api_key = saved_key
    end
end
