require 'spec_helper'
require 'set'

test_data = [['input 1', 'label 1'], ['input 2', 'label 2'], ['input 3', 'label 3'], ['input 4', 'label 4']]
text_collection = '__test_ruby_text__'
alternate_name = '__alternate_test_ruby_text__'
test_user_email = 'contact@indico.io'

describe Indico do
  before do
    api_key = ENV['INDICO_API_KEY']
    @config = { api_key: api_key}
  end

  after(:each) do
    begin
      collection = Indico::Collection.new(text_collection)
      collection.deregister()
    rescue 
    end

    begin
      collection = Indico::Collection.new(text_collection)
      collection.clear()
    rescue 
    end

    begin
      collection = Indico::Collection.new(alternate_name)
      collection.deregister()
    rescue 
    end

    begin
      collection = Indico::Collection.new(alternate_name)
      collection.clear()
    rescue 
    end
  end

  it 'should instantiate a Collection object and add data to the collection' do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data[0]) # single
    collection.add_data(test_data) # batch
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

  it "should properly register a collection" do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
    collection.train()
    collection.wait()
    collection.register()
    expect(collection.info()['registered']).to be true
    expect(collection.info()['public']).to be false
    collection.deregister()
    expect(collection.info()['registered']).to be false
    expect(collection.info()['public']).to be false
    collection.clear()
  end

  it "should properly register a public collection" do 
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
    collection.train()
    collection.wait()
    config = Hash.new()
    config["make_public"] = true
    collection.register(config)
    expect(collection.info()['registered']).to be true
    expect(collection.info()['public']).to be true
    collection.deregister()
    expect(collection.info()['registered']).to be false
    expect(collection.info()['public']).to be false
    collection.clear()
  end

  it "should give a user read permissions" do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
    collection.train()
    collection.wait()
    collection.register()
    collection.authorize(email=test_user_email, permission_type='read')
    expect(collection.info()['permissions']['read'] || []).to include(test_user_email)
    expect(collection.info()['permissions']['write'] || []).not_to include(test_user_email)
    collection.deauthorize(email=test_user_email)
    expect(collection.info()['permissions']['read'] || []).not_to include(test_user_email)
    expect(collection.info()['permissions']['write'] || []).not_to include(test_user_email)
    collection.deregister()
    collection.clear()
  end

  it "should give a user write permissions" do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
    collection.train()
    collection.wait()
    collection.register()
    collection.authorize(email=test_user_email, permission_type='write')
    expect(collection.info()['permissions']['write'] || []).to include(test_user_email)
    expect(collection.info()['permissions']['read'] || []).not_to include(test_user_email)
    collection.deauthorize(email=test_user_email)
    expect(collection.info()['permissions']['read'] || []).not_to include(test_user_email)
    expect(collection.info()['permissions']['write'] || []).not_to include(test_user_email)
    collection.deregister()
    collection.clear()
  end

  it "should rename a collection" do
    collection = Indico::Collection.new(text_collection)
    collection.add_data(test_data)
    collection.train()
    collection.wait()
    collection.rename(alternate_name)
    new_collection = Indico::Collection.new(alternate_name)

    # name no longer exists
    collection = Indico::Collection.new(text_collection)
    expect { collection.train() }.to raise_error

    # collection is now accessible via the alternate name
    new_collection.info()
    new_collection.clear()
  end
end