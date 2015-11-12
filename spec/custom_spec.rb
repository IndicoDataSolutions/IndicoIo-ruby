require 'spec_helper'
require 'set'

test_data = [['input 1', 'label 1'], ['input 2', 'label 2'], ['input 3', 'label 3'], ['input 4', 'label 4']]
text_collection = '__test_ruby_text__'

describe Indico do
  before do
    api_key = ENV['INDICO_API_KEY']
    @config = { api_key: api_key}
  end

  after(:each) do
    begin
      collection = Indico::Collection.new(text_collection)
      collection.clear()
    rescue 
      # no op -- collection doesn't
    end
  end

  it 'should instantiate a Collection object and add data to the collection' do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
  end

  it "should add data, train, and predict" do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
    collection.train()
    collection.wait()
    result = collection.predict(test_data[0][0])
    expect(result).to have_key(test_data[0][1])
  end

  it "should list collections" do
      collection = Indico::Collection.new(text_collection)
      collection.add_data(test_data)
      collection.train()
      collection.wait()
      expect(Indico::collections()).to have_key(text_collection)
  end

  it "should clear an example" do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
    collection.train()
    collection.wait()
    result = collection.predict(test_data[0][0])
    expect(result).to have_key(test_data[0][1])
    collection.remove_example(test_data[0][0])
    collection.train()
    collection.wait()
    result = collection.predict(test_data[0][0])
    expect(result).to_not have_key(test_data[0][1])
  end

  it "should clear a collection" do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
    collection.train()
    collection.wait()
    expect(Indico::collections()).to have_key(text_collection)
    collection.clear()
    expect(Indico::collections()).to_not have_key(text_collection)
  end 

end
