module Indico
  def self.language(test_text, api="remote")
    Indico::Results.new api_handler(test_text, api, "language")
  end

  def self.political(test_text, api="remote")
    Indico::Results.new api_handler(test_text, api, "political")
  end

  def self.text_tags(test_text, api="remote")
    Indico::Results.new api_handler(test_text, api, "texttags")
  end

  def self.fer(face, api="remote")
    Indico::Results.new api_handler(face, api, "fer")
  end
end


