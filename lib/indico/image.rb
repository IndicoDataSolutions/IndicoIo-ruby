require 'oily_png'
require 'base64'

module Indico
  def self.preprocess(image, size)
    if image.class == String
      decoded_image = handle_string_input(image)
    elsif image.class == Array
        # Batch Request
        im_array = Array.new

        # process each image
        image.each do |_image|
          im_array.push(preprocess(_image, size))
        end

        return im_array
    else
      raise Exception.new("Image input must be filename or base64 string")
    end

    # Resize and export base64 encoded string
    if size
        decoded_image = decoded_image.resize(size, size)
    end
    
    return decoded_image.to_data_url.gsub("data:image/png;base64," ,"")
  end

  def self.handle_string_input(str)
    # Handles string input
    if File.file?(str)
      # Handling File Inputs
      return ChunkyPNG::Image.from_file(str)
    end

    regex = %r{^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$}.match(str)
    # Base 64 handling
    if regex == nil
      raise Exception.new("String is not a valid absolute filepath or base64 string")
    else
      return ChunkyPNG::Image.from_data_url("data:image/png;base64," + str.gsub("data:image/png;base64," ,""))
    end
  end

  def self.get_dimension(array)
    return [] unless array.is_a?(Array)
    return [array.size] + get_dimension(array[0])
  end

  def self.array_contains_float(array, dimens)
    # Determines whether or not the array contains floats
    if not array.is_a?(Array)
      return array.class == Float
    end
    elem = array[0]
    (0..dimens.size - 2).each do |i|
      elem = elem[0]
    end

    return elem.class == Float
  end

  def self.get_rgb(value)
    # Returns Integer encoding of RGB value used by ChunkyPNG
    return [
      ChunkyPNG::Color.r(value),
      ChunkyPNG::Color.g(value),
      ChunkyPNG::Color.b(value)
    ]
  end
end
