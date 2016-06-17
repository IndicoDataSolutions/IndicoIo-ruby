require 'spec_helper'

describe Indico do
    before do
        api_key = ENV['INDICO_API_KEY']
        private_cloud = 'indico-test'
        @config = { api_key: api_key, cloud: private_cloud}
    end

    it 'should tag text with correct political tags' do
      expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
      data = ['Guns don\'t kill people.', ' People kill people.']
      response = Indico.political(data, @config)

      expect(Set.new(response[0].keys)).to eql(expected_keys)
      expect(Set.new(response[1].keys)).to eql(expected_keys)
    end

    it 'should tag text with correct political tags' do
      expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
      response = Indico.political('Guns don\'t kill people. People kill people.')

      expect(Set.new(response.keys)).to eql(expected_keys)
    end

    it 'single political should return the right response' do
        expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))

        config = @config.clone
        config["version"] = 1
        response = Indico.political('Guns don\'t kill people. People kill people.')

        expect(Set.new(response.keys)).to eql(expected_keys)
    end

    it 'batch political should return the right response' do
        expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
        data = 'Guns don\'t kill people. People kill people.'

        config = @config.clone
        config["version"] = 1
        response = Indico.political([data, data])

        expect(response.length).to eql(2)
        expect(Set.new(response[0].keys)).to eql(expected_keys)
        expect(Set.new(response[1].keys)).to eql(expected_keys)
    end
end
