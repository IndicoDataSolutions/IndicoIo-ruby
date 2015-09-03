require 'spec_helper'

describe Indico do
    before do
        api_key = ENV['INDICO_API_KEY']
        private_cloud = 'indico-test'
        @config = { api_key: api_key, cloud: private_cloud}
    end

    it 'single image recognition should return the right response' do
        data = File.dirname(__FILE__) + "/data/happy.png"

        config = @config.clone
        config["top_n"] = 3
        response = Indico.image_recognition(data, config)
        expect(response.keys.length).to eql(3)
    end

    it 'batch image recognition should return the right response' do
        data = File.dirname(__FILE__) + "/data/happy.png"

        config = @config.clone
        config["top_n"] = 3
        response = Indico.image_recognition([data, data], config)
        expect(response.length).to eql(2)
        expect(response[0].keys.length).to eql(3)
    end
end
