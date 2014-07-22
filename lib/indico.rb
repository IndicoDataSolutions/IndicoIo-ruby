require "indico/version"
require "indico/helper"
require "uri"
require "json"
require "net/https"

module Indico

  HEADERS = { "Content-Type" => "application/json", "Accept" => "text/plain" }

  def self.political(test_text)
    data_dict = JSON.dump({ text: test_text})
    response = make_request(base_url("political"), data_dict, HEADERS)
    JSON.parse(response.body)
  end

  def self.posneg(test_text)
    data_dict = JSON.dump({ text: test_text})
    response = make_request(base_url("sentiment"), data_dict, HEADERS)
    JSON.parse(response.body)
  end

  def self.sentiment(*args)
    self.posneg(*args)
  end

  def self.fer(face)
    data_dict = JSON.dump({ face: face})
    response = make_request(base_url("fer"), data_dict, HEADERS)
    JSON.parse(response.body)
  end

  def self.facial_features(face)
    data_dict = JSON.dump({ face: face})
    response = make_request(base_url("facialfeatures"), data_dict, HEADERS)
    response_dict = JSON.parse(response.body)
    response_dict['response']
  end

end
