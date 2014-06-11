require 'spec_helper'

describe Indico do

  it "should tag text with correct political tags" do
    tagged_text = Indico.political("Guns don't kill people. People kill people.") # Guns don't kill people. People kill people.

    expect(tagged_text).to eql({"Conservative"=>0.8412676366335048, "Green"=>0.0, "Liberal"=>1.0, "Libertarian"=>0.7437584040439491})
  end

  it "should tag text with correct spam tags" do
    tagged_text = Indico.spam("Free car!")

    expect(tagged_text).to eql({"Ham"=>0.0, "Spam"=>1.0})
  end

  it "should tag text with correct sentiment tags" do
    tagged_text = Indico.posneg("Worst movie ever.")

    expect(tagged_text).to eql({"Sentiment" => 0.07062467665597527})
  end

end