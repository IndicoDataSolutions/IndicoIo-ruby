require 'spec_helper'
require 'set'

describe Indico do
  before do
    api_key = ENV['INDICO_API_KEY']
    private_cloud = 'indico-test'
    @config = { api_key: api_key, cloud: private_cloud}
  end

  it 'should tag text with correct political tags' do
    expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
    response = Indico.political('Guns don\'t kill people. People kill people.')

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it 'should take variable arguments such as top_n and threshold' do
    response = Indico.text_tags('Guns don\'t kill people. People kill people.',
                                {top_n: 2})
    expect(response.keys.length).to eql(2)
  end

  it 'should tag text with correct political tags' do
    expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
    data = 'Guns don\'t kill people. People kill people.'

    # for mocking: use http to redirect requests to our public cloud endpoint
    Indico.cloud_protocol = 'http://'
    response = Indico.political(data, @config)
    Indico.cloud_protocol = 'https://'
    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it 'should tag text with correct sentiment tags' do
    response = Indico.sentiment('Worst movie ever.')

    expect(response < 0.5).to eql(true)
  end

  it 'should tag text with correct language tags' do
    expected_keys = Set.new([
      'English',
      'Spanish',
      'Tagalog',
      'Esperanto',
      'French',
      'Chinese',
      'French',
      'Bulgarian',
      'Latin',
      'Slovak',
      'Hebrew',
      'Russian',
      'German',
      'Japanese',
      'Korean',
      'Portuguese',
      'Italian',
      'Polish',
      'Turkish',
      'Dutch',
      'Arabic',
      'Persian (Farsi)',
      'Czech',
      'Swedish',
      'Indonesian',
      'Vietnamese',
      'Romanian',
      'Greek',
      'Danish',
      'Hungarian',
      'Thai',
      'Finnish',
      'Norwegian',
      'Lithuanian'
    ])
    response = Indico.language('Quis custodiet ipsos custodes')

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it 'should tag text with correct text tags' do
    expected_keys = Set.new(%w(fashion art energy economics entrepreneur
                               books politics gardening nba conservative
                               technology startups relationships education
                               humor psychology bicycling investing travel
                               cooking christianity environment religion health
                               hockey pets music soccer guns gaming jobs
                               business nature food cars photography philosophy
                               geek sports baseball news television
                               entertainment parenting comics science nfl
                               programming personalfinance atheism movies anime
                               fitness military realestate history))
    response = Indico.text_tags('Guns don\'t kill people. People kill people.')

    expect Set.new(response.keys).subset?(Set.new(expected_keys))
  end

  it 'should tag face with correct facial expression' do
    expected_keys = Set.new(%w(Angry Sad Neutral Surprise Fear Happy))
    test_face = Array.new(48) { Array.new(48) { rand(100) / 100.0 } }

    response = Indico.fer(test_face)

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it 'should tag face with correct facial features' do
    test_face = Array.new(48) { Array.new(48) { rand(100) / 100.0 } }
    response = Indico.facial_features(test_face)

    expect(response.length).to eql(48)
  end

  it 'should tag image with correct image features' do
    test_image = Array.new(48) { Array.new(48) { rand(100) / 100.0 } }
    response = Indico.image_features(test_image)

    expect(response.length).to eql(2048)
  end

  it "should tag rgb image with correct image features" do
    test_image = Array.new(48){Array.new(48){Array.new(3){rand(100)/100.0}}}
    response = Indico.image_features(test_image)

    expect(response.length).to eql(2048)
  end

  # Uncomment when frontend updated to accept image urls
  # it 'should accept image urls' do
  #   response = Indico.image_features('http://icons.iconarchive.com/icons/' +
  #                                    'oxygen-icons.org/oxygen/48/' +
  #                                    'Emotes-face-smile-icon.png')

  #   expect(response.length).to eql(2048)
  # end
end
