require 'oily_png'
require 'base64'

module Indico
  def self.preprocess(image, size, min_axis)
    
    if image.class == String
      decoded_image = handle_string_input(image)
    elsif image.class == Array
      # Batch Request
      im_array = Array.new

      # process each image
      image.each do |_image|
        im_array.push(preprocess(_image, size, min_axis))
      end

      return im_array
    else
      raise Exception.new("Image input must be filename or base64 string")
    end

    if size
      if min_axis
        image = self.min_resize(decoded_image, size)
      else
        image = decoded_image.resize(size, size) 
      end
    else
      image = decoded_image
    end

    # Resize and export base64 encoded string
    return image.to_data_url.gsub("data:image/png;base64," ,"")
  end

  def self.min_resize(decoded_image, size)
    img_size = [decoded_image.width, decoded_image.height]
    min_idx, max_idx = img_size[0] < img_size[1] ? [0, 1] : [1, 0]
    aspect = img_size[max_idx] / Float(img_size[min_idx])
    if aspect > 10
      warn("An aspect ratio greater than 10:1 is not recommended")
    end
    size_arr = [0, 0]
    size_arr[min_idx] = size
    size_arr[max_idx] = Integer(size * aspect)
    image = decoded_image.resize(size_arr[0], size_arr[1])
    return image
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
