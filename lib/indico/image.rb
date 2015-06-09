require 'oily_png'
require 'base64'

module Indico
  def self.preprocess(image, size, batch)
    # image is [[f,f,f,f, ...], ..] or [[[f,f,f],[f,f,f],[f,f,f]], ...]
    if batch
      # Batch Request
      im_array = Array.new

      # process each image
      image.each do |_image|
        im_array.push(preprocess(_image, size, false))
      end

      return im_array
    end

    if image.class == String
      decoded_image = handle_string_input(image)
    elsif image.class == Array
      decoded_image = handle_array_input(image)
    else
      raise Exception.new("Image input must be nested array of pixels, filename, or base64 string")
    end

    # Resize and export base64 encoded string
    return decoded_image.resize(size, size).to_data_url.gsub("data:image/png;base64," ,"")
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

  def self.handle_array_input(image)
    # Handles properly formatting and loading array of pixels
    # Single Request
    warn "Warning! Array input as image will be deprecated in the next major release.\n Consider using filepaths or base64 encoded strings"
    
    dimens = get_dimension(image)
    isFloat = array_contains_float(image, dimens)

    if dimens.size > 3
      raise Exception.new("Nested array of image must be [[p, p, ...]] or [[[r,g,b], [r,g,b], ...]]")
    end

    decoded_image = ChunkyPNG::Image.new(dimens[0], dimens[1])

    # Manually loading the pixels into the ChunkyImage object
    (0..dimens[0] - 1).each do |x|
      (0..dimens[1] - 1).each do |y|
        pixel = image[x][y]
        if pixel.is_a?(Array)
          if isFloat
            pixel.map! {|a| (255 * a).to_i}
          end
          decoded_image.set_pixel(x,y, ChunkyPNG::Color.rgb(pixel[0], pixel[1], pixel[2]))
        else
          if isFloat
            pixel = (pixel * 255).to_i
          end
          decoded_image.set_pixel(x,y, ChunkyPNG::Color.rgb(pixel, pixel, pixel))
        end
      end
    end

    return decoded_image
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
