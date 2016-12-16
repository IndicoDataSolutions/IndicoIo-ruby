require 'base64'

module Indico
    def self.preprocess_pdf(pdf)
        if pdf.class == Array
            # Batch Request
            pdf_array = Array.new

            # process each image
            pdf.each do |_pdf|
                pdf_array.push(preprocess_pdf(_pdf))
            end

            return pdf_array
        elsif pdf.class != String
            raise Exception.new("PDF input must be filename, url or base64 string")
        end

        begin
            return Base64.encode64(File.read(pdf))
        rescue
            # likely a url or a base64 encoded string already
            return pdf
        end
    end
end
