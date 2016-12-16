require 'spec_helper'

describe Indico do
    before do
        api_key = ENV['INDICO_API_KEY']
        private_cloud = 'indico-test'
        @config = { api_key: api_key, cloud: private_cloud}
    end

    it 'should properly handle pdf urls' do
        pdf_url = "https://s3-us-west-2.amazonaws.com/indico-test-data/test.pdf"

        response = Indico.pdf_extraction(pdf_url, @config)
        expected_keys = Set.new(%w(metadata text))

        expect(Set.new(response.keys)).to eql(expected_keys)
    end

    it 'should properly handle local pdf files' do
        pdf_path = File.expand_path(
            File.join(File.dirname(__FILE__), "data", "test.pdf")
        )

        response = Indico.pdf_extraction(pdf_path, @config)
        expected_keys = Set.new(%w(metadata text))

        expect(Set.new(response.keys)).to eql(expected_keys)
    end

    it 'should properly handle array of local pdf files' do
        pdf_path = File.expand_path(
            File.join(File.dirname(__FILE__), "data", "test.pdf")
        )
        arr = Array.new()
        arr.push(pdf_path)
        arr.push(pdf_path)

        response = Indico.pdf_extraction(arr, @config)
        expected_keys = Set.new(%w(metadata text))

        expect(Set.new(response[0].keys)).to eql(expected_keys)
    end
end
