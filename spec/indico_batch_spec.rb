require 'spec_helper'
require 'set'

describe Indico do
  before do
    api_key = ENV['INDICO_API_KEY']
    private_cloud = 'indico-test'
    @config_private_cloud = { api_key: api_key, cloud: private_cloud}
    @config = { api_key: api_key}
  end

  it 'should tag text with correct political tags' do
    expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
    data = ['Guns don\'t kill people.', ' People kill people.']
    response = Indico.batch_political(data, @config)

    expect(Set.new(response[0].keys)).to eql(expected_keys)
    expect(Set.new(response[1].keys)).to eql(expected_keys)
  end

  it 'should access a private cloud' do
    expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
    data = ['Guns don\'t kill people.', ' People kill people.']
    response = Indico.batch_political(data, @config_private_cloud)

    expect(Set.new(response[0].keys)).to eql(expected_keys)
    expect(Set.new(response[1].keys)).to eql(expected_keys)
  end

  it 'should tag text with correct sentiment tags' do
    response = Indico.batch_sentiment(['Worst movie ever.'], @config)
    expect(response[0] < 0.5).to eql(true)
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

    data = ['Quis custodiet ipsos custodes', 'Clearly english, foo!']
    response = Indico.batch_language(data, @config)

    expect(Set.new(response[0].keys)).to eql(expected_keys)
    expect(Set.new(response[1].keys)).to eql(expected_keys)
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

    data = ['Guns don\'t kill people.', 'People kill people.']
    response = Indico.batch_text_tags(data, @config)

    expect Set.new(response[0].keys).subset?(Set.new(expected_keys))
    expect Set.new(response[1].keys).subset?(Set.new(expected_keys))
  end

  it 'should tag face with correct facial expression' do
    expected_keys = Set.new(%w(Angry Sad Neutral Surprise Fear Happy))
    test_face = Array.new(48) { Array.new(48) { rand(100) / 100.0 } }
    response = Indico.batch_fer([test_face, test_face], @config)

    expect(Set.new(response[0].keys)).to eql(expected_keys)
    expect(Set.new(response[1].keys)).to eql(expected_keys)
  end

  it 'should tag face with correct facial features' do
    test_face = Array.new(48) { Array.new(48) { rand(100) / 100.0 } }
    response = Indico.batch_facial_features([test_face, test_face], @config)
    expect(response[0].length).to eql(48)
    expect(response[1].length).to eql(48)
  end

  it 'should tag image with correct image features' do
    test_image = Array.new(48) { Array.new(48) { rand(100) / 100.0 } }
    response = Indico.batch_image_features([test_image, test_image], @config)
    expect(response[0].length).to eql(2048)
    expect(response[1].length).to eql(2048)
  end

  # Uncomment when frontend updated to accept image urls
  # it "should accept image urls" do
  #   test_image = 'http://icons.iconarchive.com/icons/oxygen-icons.org/' +
  #                'oxygen/48/Emotes-face-smile-icon.png'
  #   response = Indico.batch_image_features([test_image, test_image],
  #                                          @config)

  #   expect(response[0].length).to eql(2048)
  #   expect(response[1].length).to eql(2048)
  # end
end
