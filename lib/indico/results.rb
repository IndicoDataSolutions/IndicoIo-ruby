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

    def [](key)
      key = key.to_s
      raw[key] || raw[key.capitalize]
    end

    def take(n=5)
      Hash[sorted_raw.take(n)]
    end

    private
    def sorted_raw
      @sorted_raw ||= raw.sort_by{|k,v| -v}
    end

    def method_missing(symbol, *args)
      method = symbol.to_s
      if has_value?(method)
        self.[](method)
      elsif is_question?(method)
        most_likely.casecmp(method.chomp('?')) == 0
      else
        super args
      end
    end

    def has_value?(value)
      comparable_values.include?(value.to_s.downcase)
    end

    def is_question?(value)
      value[-1] == '?' && has_value?(value.chomp('?'))
    end

    def comparable_values
      @comparable_values ||= raw.keys.map(&:downcase)
    end
  end
end
