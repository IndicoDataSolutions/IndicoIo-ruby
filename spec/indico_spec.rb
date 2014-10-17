require 'spec_helper'
require 'set'

describe Indico do

  it "should tag text with correct political tags" do
    expected_keys = Set.new(["Conservative", "Green", "Liberal", "Libertarian"])
    response = Indico.political("Guns don't kill people. People kill people.") # Guns don't kill people. People kill people.

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should tag text with correct sentiment tags" do
    response = Indico.sentiment("Worst movie ever.")

    expect(response).to be < 0.5
  end

  it "should tag text with correct language tags" do
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

  it "should tag face with correct facial expression" do
    expected_keys = Set.new(["Angry", "Sad", "Neutral", "Surprise", "Fear", "Happy"])
    test_face = 0.step(1, 1.0/(48.0*48.0)).to_a[0..-2].each_slice(48).to_a
    response = Indico.fer(test_face)

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should return a facial feature vector" do
    test_face = 0.step(1, 1.0/(48.0*48.0)).to_a[0..-2].each_slice(48).to_a
    response = Indico.facial_features(test_face)

    expect(response.length).to eql(48)
  end

  it "should return an image features vector" do
    test_image = 0.step(1, 1.0/(48.0*48.0)).to_a[0..-2].each_slice(48).to_a
    response = Indico.image_features(test_image)

    expect(response.length).to eql(2048)
  end

end