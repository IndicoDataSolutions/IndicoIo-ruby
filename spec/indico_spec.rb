# encoding: UTF-8

require 'spec_helper'
require 'set'
require 'oily_png'

describe Indico do
  before do
    api_key = ENV['INDICO_API_KEY']
    private_cloud = 'indico-test'
    @config = { api_key: api_key, cloud: private_cloud}
  end

  it 'should return personality values for text' do
    expected_keys = Set.new(%w(openness extraversion conscientiousness agreeableness))
    response = Indico.personality('I love my friends!')

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it 'should return personas for text' do
    expected_keys = Set.new(%w(architect mediator executive entertainer))
    response = Indico.personas('I love my friends!')

    expected_keys.each do |key|
      expect(Set.new(response.keys)).to include(key)
    end

    response = Indico.personas('I love my friends!', {top_n: 5})

    expect(response.length).to eql(5)
  end

  it 'should tag text with correct emotion tags' do
    expected_keys = Set.new(%w(anger fear joy sadness surprise))
    data = "I did it. I got into Grad School. Not just any program, but a GREAT program. :-)"

    response = Indico.emotion(data)
    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it 'should tag text with correct sentiment tags' do
    response = Indico.sentiment('Worst movie ever.')

    expect(response < 0.5).to eql(true)
  end

  it 'should tag text with correct sentimenthq tags' do
    response = Indico.sentiment_hq('Worst movie ever.')

    expect(response < 0.5).to eql(true)
  end

  it 'should tag text with correct twitter engagment tags' do
    response = Indico.twitter_engagement('#Breaking rt if you <3 pic.twitter.com @Startup')

    expect(response < 1).to eql(true)
    expect(response > 0).to eql(true)
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

  it 'should tag text with correct keywords' do
    expected_keys = Set.new(%w(guns kill people))
    response = Indico.keywords('Guns don\'t kill people. People kill people.')

    expect Set.new(response.keys).subset?(Set.new(expected_keys))
  end

  it 'should tag text with correct keywords for auto detect language' do
    text = "La semaine suivante, il remporte sa premiere victoire, dans la descente de Val Gardena en Italie, près de cinq ans après la dernière victoire en Coupe du monde d'un Français dans cette discipline, avec le succès de Nicolas Burtin à Kvitfjell."
    config = { "language" => "detect" }
    response = Indico.keywords(text, config)

    expect Set.new(response.keys).subset?(Set.new(text.gsub(/\s+/m, ' ').strip.split(" ")))
  end

  it 'should tag text with correct keywords for specified language' do
    text = "La semaine suivante, il remporte sa premiere victoire, dans la descente de Val Gardena en Italie, près de cinq ans après la dernière victoire en Coupe du monde d'un Français dans cette discipline, avec le succès de Nicolas Burtin à Kvitfjell."
    config = { "language" => "French" }
    response = Indico.keywords(text, config)

    expect Set.new(response.keys).subset?(Set.new(text.gsub(/\s+/m, ' ').strip.split(" ")))
  end

  it 'should return the relevance between a set of documents and a set of query strings' do
    text = 'If patience is a necessary quality for a Jedi, fans who have gathered in front of a Hollywood theater in anticipation of Thursday\'s midnight screening of "The Force Awakens" are surely experts in the ways of the Force.'
    query = 'star wars'
    result = Indico.relevance(text, query)
    expect result[0] >= 0.5
  end

  it 'should return the feature vector for given input text' do
    text = 'Queen of England'
    result = Indico.text_features(text)
    expect result.length == 300
  end

  it 'should return people found in the text provided' do
    text = "Bill Gates, founder of Microsoft, can jump over a chair from standing position"
    result = Indico.people(text).sort_by { |k| -k["confidence"] }
    v1_result = Indico.people(text, config={version: "2"}).sort_by { |k| -k["confidence"] }
    expect result[0]["text"].include? "Bill Gates"
    expect result[0]["confidence"] != v1_result[0]["confidence"]
  end

  it 'should return organizations found in the text provided' do
    text = "Chinese internet giant Alibaba is to buy Hong Kong-based newspaper the South China Morning Post (SCMP)."
    result = Indico.organizations(text).sort_by { |k| -k["confidence"] }
    expect result[0]["text"].include? "Alibaba"
    v1_result = Indico.organizations(text, config={version: "2"}).sort_by { |k| -k["confidence"] }
    expect result[0]["confidence"] != v1_result[0]["confidence"]
  end

  it 'should return places found in the text provided' do
    text = "Alibaba to buy Hong Kong's South China Morning Post"
    result = Indico.places(text).sort_by { |k| -k["confidence"] }
    expect result[0]["text"].include? "China"
    v1_result = Indico.places(text, config={version: "2"}).sort_by { |k| -k["confidence"] }
    expect result[0]["confidence"] != v1_result[0]["confidence"]
  end

  it 'should return a text summary' do
    text = "We've been debunking this hoax for SEVEN YEARS now, and here we are doing it again. " \
           "No, Facebook hasn't changed its privacy settings. " \
           "No, what you post doesn't belong to Facebook now. "
    result = Indico.summarization(text, {top_n: 1})
    expect(result.length).to eql(1)
  end

  it 'should tag face with correct facial expression' do
    expected_keys = Set.new(%w(Angry Sad Neutral Surprise Fear Happy))
    test_face= File.dirname(__FILE__) + "/data/happy.png"
    silent_warnings do
      response = Indico.fer(test_face)
      expect(Set.new(response.keys)).to eql(expected_keys)
    end
  end

  it 'should tag face with correct facial features' do
    test_face= File.dirname(__FILE__) + "/data/happy.png"
    silent_warnings do
      response = Indico.facial_features(test_face)
      expect(response.length).to eql(48)
    end
  end

  it 'should locate a face in the image' do
    expected_keys = Set.new(%w(top_left_corner bottom_right_corner))
    response = Indico.facial_localization(File.dirname(__FILE__) + "/data/happy.png")[0]
    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it 'should tag noise as sfw' do
    test_image= File.dirname(__FILE__) + "/data/happy.png"
    silent_warnings do
      response = Indico.content_filtering(test_image)
      expect(response).to be < 0.5
    end
  end

  it 'should tag image with correct image features' do
    test_image= File.dirname(__FILE__) + "/data/happy.png"
    silent_warnings do
      response = Indico.image_features(test_image)
      expect(response.length).to eql(4096)
    end
  end

  it 'should tag image with correct image features with jpg files' do
    test_image= File.dirname(__FILE__) + "/data/dog.jpg"
    silent_warnings do
      response = Indico.image_features(test_image)
      expect(response.length).to eql(4096)
    end
  end

  it "should tag rgb image with correct image features" do
    test_image = File.open(File.dirname(__FILE__) + "/data/happy64.txt", 'rb') { |f| f.read }
    silent_warnings do
      response = Indico.image_features(test_image)
      expect(response.length).to eql(4096)
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
    expected_keys = Set.new(TEXT_APIS) - Set.new(MULTIAPI_NOT_SUPPORTED)
    response = Indico.analyze_text("Worst movie ever.")

    expect(response.class).to eql(Hash)
    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should respond with all text apis called by default" do
    expected_keys = Set.new(TEXT_APIS) - Set.new(MULTIAPI_NOT_SUPPORTED)
    response = Indico.analyze_text("Worst movie ever.")

    expect(response.class).to eql(Hash)
    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should respond with all image apis called" do
    test_image = File.open(File.dirname(__FILE__) + "/data/happy64.txt", 'rb') { |f| f.read }
    expected_keys = Set.new(IMAGE_APIS)
    silent_warnings do
      response = Indico.analyze_image(test_image, IMAGE_APIS)

      expect(response.class).to eql(Hash)
      expect(Set.new(response.keys)).to eql(expected_keys)
    end
  end

  it "should respond with all image apis called on int array" do
    test_image = File.open(File.dirname(__FILE__) + "/data/happy64.txt", 'rb') { |f| f.read }
    expected_keys = Set.new(IMAGE_APIS)
    silent_warnings do
      response = Indico.analyze_image(test_image, IMAGE_APIS)

      expect(response.class).to eql(Hash)
      expect(Set.new(response.keys)).to eql(expected_keys)
    end
  end

  it 'should properly resize an image with min_axis set' do
    test_image = File.open(File.dirname(__FILE__) + "/data/happy64.txt", 'rb') { |f| f.read }
    silent_warnings do
      image = Indico.preprocess(test_image, 128, true)
      # Can't find a consistent way to load from b64 content (ChunkyPNG API has changed)
      # For now let's simply ensure that no exceptions are raised
    end
  end

  it 'should respond with proper results from intersections api' do
    text = ['data', 'baseball', 'weather']
    apis = ['twitter_engagement', 'sentiment']
    response = Indico.intersections(text, apis)
    expect(Set.new(response.keys)).to eql(Set.new(['twitter_engagement']))
  end

  it 'should respond with proper results from raw intersections api' do
    data = {}
    data['sentiment'] = [0.1, 0.2, 0.3];
    data['twitter_engagement'] = [0.1, 0.2, 0.3]
    response = Indico.intersections(data, ['sentiment', 'twitter_engagement'])
    expect(Set.new(response.keys)).to eql(Set.new(['sentiment']))
  end

  it 'should accept image urls' do
    response = Indico.image_features('http://icons.iconarchive.com/icons/' +
                                     'oxygen-icons.org/oxygen/48/' +
                                     'Emotes-face-smile-icon.png')

    expect(response.length).to eql(4096)
  end
end
