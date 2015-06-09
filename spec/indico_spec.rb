require 'spec_helper'
require 'set'
require 'oily_png'

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
    silent_warnings do
      response = Indico.fer(test_face)
      expect(Set.new(response.keys)).to eql(expected_keys)
    end
  end

  it 'should tag face with correct facial features' do
    test_face = Array.new(48) { Array.new(48) { rand(100) / 100.0 } }
    silent_warnings do
      response = Indico.facial_features(test_face)
      expect(response.length).to eql(48)
    end
  end

  it 'should tag image with correct image features' do
    test_image = Array.new(48) { Array.new(48) { rand(100) / 100.0 } }
    silent_warnings do
      response = Indico.image_features(test_image)
      expect(response.length).to eql(2048)
    end
  end

  it "should tag rgb image with correct image features" do
    test_image = Array.new(48){Array.new(48){Array.new(3){rand(100)/100.0}}}
    silent_warnings do
      response = Indico.image_features(test_image)
      expect(response.length).to eql(2048)
    end
  end

  it "should be able to load image from path" do
    expected_keys = Set.new(%w(Angry Sad Neutral Surprise Fear Happy))
    response = Indico.fer(File.dirname(__FILE__) + "/data/happy.png")

    expect(Set.new(response.keys)).to eql(expected_keys)
    expect(response["Happy"]).to be > 0.5
  end

  it "should be able to load image from b64" do
    expected_keys = Set.new(%w(Angry Sad Neutral Surprise Fear Happy))
    response = Indico.fer(File.open(File.dirname(__FILE__) + "/data/happy64.txt", 'rb') { |f| f.read })

    expect(Set.new(response.keys)).to eql(expected_keys)
    expect(response["Happy"]).to be > 0.5
  end

  it "should respond with all text apis called" do
    expected_keys = Set.new(TEXT_APIS)
    response = Indico.predict_text("Worst movie ever.", TEXT_APIS)

    expect(response.class).to eql(Hash)
    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should respond with all text apis called by default" do
    expected_keys = Set.new(TEXT_APIS)
    response = Indico.predict_text("Worst movie ever.")

    expect(response.class).to eql(Hash)
    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should respond with all image apis called" do
    test_image = Array.new(48){Array.new(48){Array.new(3){rand(100)/100.0}}}
    expected_keys = Set.new(IMAGE_APIS)
    response = Indico.predict_image(test_image, IMAGE_APIS)

    expect(response.class).to eql(Hash)
    expect(Set.new(response.keys)).to eql(expected_keys)
    expect(response["fer"].has_key?("results")).to eql(true)
  end

  it "should respond with all text apis called in batch" do
    expected_keys = Set.new(TEXT_APIS)
    response = Indico.batch_predict_text(["Worst movie ever."], TEXT_APIS)

    expect(response.class).to eql(Hash)
    expect(Set.new(response.keys)).to eql(expected_keys)
    expect(response["sentiment"].has_key?("results")).to eql(true)
  end

  # Uncomment when frontend updated to accept image urls
  # it 'should accept image urls' do
  #   response = Indico.image_features('http://icons.iconarchive.com/icons/' +
  #                                    'oxygen-icons.org/oxygen/48/' +
  #                                    'Emotes-face-smile-icon.png')

  #   expect(response.length).to eql(2048)
  # end
end
