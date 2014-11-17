module Indico
  class Results
    attr_reader :raw

    def initialize(raw_data)
      @raw = raw_data
    end

    def most_likely
      sorted_raw.first[0]
    end

    def least_likely
      sorted_raw.last[0]
    end

    def values
      sorted_raw.map(&:first)
    end

    def probabilities
      sorted_raw.map(&:last)
    end

    def sorted
      @sorted ||= Hash[sorted_raw]
    end

    private
    def sorted_raw
      @sorted_raw ||= raw.sort_by{|k,v| -v}
    end
  end
end
