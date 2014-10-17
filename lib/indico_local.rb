require "indico"

module IndicoLocal

  def self.political(test_text)
    Indico.political(test_text, "local")
  end

  def self.posneg(test_text)
    Indico.posneg(test_text, "local")
  end

  def self.sentiment(*args)
    self.posneg(*args)
  end

  def self.language(test_text)
    Indico.language(test_text, "local")
  end

  def self.fer(face)
    Indico.fer(face, "local")
  end

  def self.facial_features(face)
    Indico.facial_features(face, "local")
  end

  def self.image_features(face)
    Indico.image_features(image, "local")
  end

end