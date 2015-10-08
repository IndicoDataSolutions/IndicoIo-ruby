require 'oily_png'
require 'base64'
require 'uri'

module Indico
    def self.preprocess(image, size, min_axis)
        if image.class == Array
            # Batch Request
            im_array = Array.new

            # process each image
            image.each do |_image|
                im_array.push(preprocess(_image, size, min_axis))
            end

            return im_array
        elsif image.class != String
            raise Exception.new("Image input must be filename or base64 string")
        end

        # Resize and export base64 encoded string
        return handle_image_input(image, size, min_axis)
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

    def self.handle_image_input(str, size, min_axis)
        # Handles string input
        if File.file?(str)
            # Handling File Inputs
            begin
                image = ChunkyPNG::Image.from_file(str)
                if min_axis
                    image = self.min_resize(image, size)
                else
                    image = image.resize(size, size)
                end
                image = image.to_data_url.gsub("data:image/png;base64," ,"")
            rescue
                File.open(str, 'r') do |file|
                    image = Base64.encode64(file.read)
                end
            end
        elsif str =~ /\A#{URI::regexp}\z/
            image = str
        else
            begin
                image = ChunkyPNG::Image.from_data_url("data:image/png;base64," + str.gsub("data:image/png;base64," ,""))
                if min_axis
                    image = self.min_resize(image, size)
                else
                    image = image.resize(size, size)
                end
                image = image.to_data_url.gsub("data:image/png;base64," ,"")
            rescue
                image = str
            end
        end

        return image
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
