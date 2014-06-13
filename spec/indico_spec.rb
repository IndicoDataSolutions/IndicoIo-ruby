require 'spec_helper'
require 'set'

describe Indico do

  it "should tag text with correct political tags" do
    expected_keys = Set.new(["Conservative", "Green", "Liberal", "Libertarian"])
    response = Indico.political("Guns don't kill people. People kill people.") # Guns don't kill people. People kill people.

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should tag text with correct spam tags" do
    expected_keys = Set.new(["Ham", "Spam"])
    response = Indico.spam("Free car!")

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should tag text with correct sentiment tags" do
    expected_keys = Set.new(["Sentiment"])
    response = Indico.sentiment("Worst movie ever.")

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should tag face with correct faciel expression" do
    expected_keys = Set.new(["Angry", "Sad", "Neutral", "Surprise", "Fear", "Happy"])
    test_face = 0.step(50, 50.0/(48.0*48.0)).to_a[0..-2].each_slice(48).to_a
    response = Indico.fer(test_face)

    expect(Set.new(response.keys)).to eql(expected_keys)
  end

  it "should tag face with correct faciel features" do
    test_face = 0.step(50, 50.0/(48.0*48.0)).to_a[0..-2].each_slice(48).to_a
    response = Indico.facial_features(test_face)

    expect(response.length).to eql(48)
  end

end