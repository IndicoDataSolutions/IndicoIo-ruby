require 'spec_helper'

describe Indico do
    before do
        api_key = ENV['INDICO_API_KEY']
        private_cloud = 'indico-test'
        @config = { api_key: api_key, cloud: private_cloud}
    end

    it 'single keywords should return the right response' do
        data = "A working API is key to success for our company"

        config = @config.clone
        config["version"] = 2
        response = Indico.keywords(data, config)

        response.keys.each { |key| expect(data.include? key)}
    end

    it 'batch keywords should return the right response' do
        data = "A working API is key to success for our company"

        config = @config.clone
        config["version"] = 2
        response = Indico.keywords([data, data], config)

        expect(response.length).to eql(2)
        response[0].keys.each { |key| expect(data.include? key)}
    end
end
