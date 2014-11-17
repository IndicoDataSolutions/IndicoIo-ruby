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

    def take(n=5)
      Hash[sorted_raw.take(n)]
    end

    private
    def sorted_raw
      @sorted_raw ||= raw.sort_by{|k,v| -v}
    end

    def method_missing(symbol, *args)
      method = symbol.to_s.capitalize
      if has_key?(method)
        raw[method] || raw[method.downcase]
      elsif method[-1] == '?' && has_key?(method[0...-1])
        !!most_likely.match(/#{method[0...-1]}/i)
      else
        super args
      end
    end

    def has_key?(key)
      raw.has_key?(key.capitalize) || raw.has_key?(key.downcase)
    end
  end
end
