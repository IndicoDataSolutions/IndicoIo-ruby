# require 'spec_helper'
#
# describe Indico do
#     before do
#         api_key = ENV['INDICO_API_KEY']
#         private_cloud = 'indico-test'
#         @config = { api_key: api_key, cloud: private_cloud}
#     end
#
#     it 'should tag text with correct political tags' do
#         expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
#         data = 'Guns don\'t kill people. People kill people.'
#
#         # for mocking: use http to redirect requests to our public cloud endpoint
#         config = @config.clone
#         config["version"] = 1
#         print config
#         Indico.cloud_protocol = 'http://'
#         response = Indico.political(data, config)
#         Indico.cloud_protocol = 'https://'
#         expect(Set.new(response.keys)).to eql(expected_keys)
#     end
# end
