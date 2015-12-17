require 'spec_helper'
require 'set'


describe Indico do
  before do
    api_key = ENV['INDICO_API_KEY']
    private_cloud = 'indico-test'
    @config_private_cloud = { api_key: api_key, cloud: private_cloud}
    @config = { api_key: api_key}
    # FIXME Remove when sentiment_hq is released
    TEXT_APIS.delete("sentiment_hq")
  end

  it 'should tag text with correct political tags' do
    expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
    data = ['Guns don\'t kill people.', ' People kill people.']
    response = Indico.political(data, @config)

    expect(Set.new(response[0].keys)).to eql(expected_keys)
    expect(Set.new(response[1].keys)).to eql(expected_keys)
  end

  it 'should return personality values for text' do
    expected_keys = Set.new(%w(openness extraversion conscientiousness agreeableness))
    
    data = ['I love my friends!', 'I like to be alone']
    response = Indico.personality(data)

    expect(Set.new(response[0].keys)).to eql(expected_keys)
    expect(Set.new(response[1].keys)).to eql(expected_keys)
  end

  it 'should return personas for text' do
    expected_keys = Set.new(%w(architect mediator executive entertainer))
    data = ['I love my friends!', 'I like to be alone']
    response = Indico.personas(data)

    expected_keys.each do |key|
      expect(Set.new(response[0].keys)).to include(key)
      expect(Set.new(response[1].keys)).to include(key)
    end
  end

  it 'should return the relevance between a set of documents and a set of query strings' do
    text = ['If patience is a necessary quality for a Jedi, fans who have gathered in front of a Hollywood theater in anticipation of Thursday\'s midnight screening of "The Force Awakens" are surely experts in the ways of the Force.']
    query = ['star wars', 'jedi']
    result = Indico.relevance(text, query)
    expect result[0][0] >= 0.5
    expect result[0][0] >= 0.5
  end

  it 'should return people found in the text provided' do
    text = ["Chef Michael Solomonov's gorgeous cookbook \"Zahav\" is taking up too much space on my dining room table, but his family stories, recipes and photography keep me from shelving it."]
    text += text
    result = Indico.people(text)
    result[0] = result[0].sort_by { |k| -k["confidence"] }
    expect result[0][0]["text"].include? "Michael Solomonov"
    expect result.length == 2
  end

  it 'should return organizations found in the text provided' do
    text = ["Chinese internet giant Alibaba is to buy Hong Kong-based newspaper the South China Morning Post (SCMP)."]
    text += text
    result = Indico.organizations(text)
    result[0] = result[0].sort_by { |k| -k["confidence"] }
    expect result[0][0]["text"].include? "Alibaba"
    expect result.length == 2
  end

  it 'should return places found in the text provided' do
    text = ["Alibaba to buy Hong Kong's South China Morning Post"]
    text += text
    result = Indico.places(text)
    result[0] = result[0].sort_by { |k| -k["confidence"] }
    expect result[0][0]["text"].include? "China"
    expect result.length == 2
  end

  it 'should access a private cloud' do
    expected_keys = Set.new(%w(Conservative Green Liberal Libertarian))
    data = ['Guns don\'t kill people.', ' People kill people.']

    # for mocking: use http instead of https to route requests to our public cloud
    Indico.cloud_protocol = 'http://'
    response = Indico.political(data, @config_private_cloud)
    Indico.cloud_protocol = 'https://'

    expect(Set.new(response[0].keys)).to eql(expected_keys)
    expect(Set.new(response[1].keys)).to eql(expected_keys)
  end

  it 'should tag text with correct sentiment tags' do
    response = Indico.sentiment(['Worst movie ever.'], @config)
    expect(response[0] < 0.5).to eql(true)
  end

  it 'should tag text with correct sentiment_hq tags' do
    response = Indico.sentiment_hq(['Worst movie ever.'], @config)
    expect(response[0] < 0.5).to eql(true)
  end

  it 'should tag text with correct twitter engagment tags' do
    response = Indico.twitter_engagement(['#Breaking rt if you <3 pic.twitter.com @Startup'])

    expect(response[0] < 1).to eql(true)
    expect(response[0] > 0).to eql(true)
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
    response = Indico.language(data, @config)

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
    response = Indico.text_tags(data, @config)

    expect Set.new(response[0].keys).subset?(Set.new(expected_keys))
    expect Set.new(response[1].keys).subset?(Set.new(expected_keys))
  end

  it 'should tag text with correct keywords' do
    expected_keys = Set.new(%w(people kill guns))

    data = ['Guns don\'t kill people.', 'People kill people.']
    response = Indico.keywords(data, @config)

    expect Set.new(response[0].keys).subset?(Set.new(expected_keys))
    expect Set.new(response[1].keys).subset?(Set.new(expected_keys))
  end

  it 'should return all named entities with category breakdowns' do
    expected_keys = Set.new(%w(unknown organization location person))
    response = Indico.named_entities(['I want to move to New York City!'])
    expect(response.length).to eql(1)
    response = response[0]

    expect(response.keys.length > 0).to eql(true)
    expect(response.values[0]['confidence']).to be >= 0.75
    expect(Set.new(response.values[0]['categories'].keys)).to eql(expected_keys)

    chance_sum = response.values[0]['categories'].values.inject{|sum,x| sum + x }
    expect(chance_sum).to be > 0.9999
  end

  it 'should return no named entities when threshold is 1' do
    config = { threshold: 1 }
    response = Indico.named_entities(['I want to move to New York City!'], config)
    expect(response.length).to eql(1)
    response = response[0]
    expect(response.keys.length).to eql(0)
  end

  it 'should tag face with correct facial expression' do
    expected_keys = Set.new(%w(Angry Sad Neutral Surprise Fear Happy))
    test_face = File.dirname(__FILE__) + "/data/happy.png"
    silent_warnings do
      response = Indico.fer([test_face, test_face], @config)

      expect(Set.new(response[0].keys)).to eql(expected_keys)
      expect(Set.new(response[1].keys)).to eql(expected_keys)
    end
  end

  it 'should tag face with correct facial features' do
    test_face = File.dirname(__FILE__) + "/data/happy.png"
    silent_warnings do
      response = Indico.facial_features([test_face, test_face], @config)
      expect(response[0].length).to eql(48)
      expect(response[1].length).to eql(48)
    end
  end

  it 'should tag image with correct image features' do
    test_image = File.dirname(__FILE__) + "/data/happy.png"
    silent_warnings do
      response = Indico.image_features([test_image, test_image], @config)
      expect(response[0].length).to eql(4096)
      expect(response[1].length).to eql(4096)
    end
  end

  it 'should locate a face in the image' do
    test_image = File.dirname(__FILE__) + "/data/happy.png"
    expected_keys = Set.new(%w(top_left_corner bottom_right_corner))
    silent_warnings do
      response = Indico.facial_localization([test_image, test_image], @config)
      expect(Set.new(response[0][0].keys)).to eql(expected_keys)
      expect(Set.new(response[1][0].keys)).to eql(expected_keys)
    end
  end

  it "should respond with all text apis called in batch" do
    expected_keys = Set.new(TEXT_APIS)
    response = Indico.analyze_text(["Worst movie ever."], TEXT_APIS)

    expect(response.class).to eql(Hash)
    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should respond with all image apis called in batch" do
    test_image = File.dirname(__FILE__) + "/data/happy.png"
    expected_keys = Set.new(IMAGE_APIS)
    silent_warnings do
      response = Indico.analyze_image([test_image], IMAGE_APIS)

      expect(response.class).to eql(Hash)
      expect(Set.new(response.keys)).to eql(expected_keys)
    end
  end

  it "should respond with all image apis called on int array in batch" do
    test_image = File.dirname(__FILE__) + "/data/happy.png"
    expected_keys = Set.new(IMAGE_APIS)
    silent_warnings do
      response = Indico.analyze_image([test_image], IMAGE_APIS)

      expect(response.class).to eql(Hash)
      expect(Set.new(response.keys)).to eql(expected_keys)
    end
  end

  it "should accept image urls" do
    test_image = 'http://icons.iconarchive.com/icons/oxygen-icons.org/' +
                 'oxygen/48/Emotes-face-smile-icon.png'
    response = Indico.image_features([test_image, test_image],
                                           @config)

    expect(response[0].length).to eql(4096)
    expect(response[1].length).to eql(4096)
  end
end
