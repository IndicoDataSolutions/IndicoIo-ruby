require_relative 'spec_helper'

describe Indico::Results do
  it 'exposes a #raw method' do
    data = {a: 5, b: 6}
    result = Indico::Results.new(data)
    expect(result.raw).to eql(data)
  end

  it 'can sort the raw data' do
    data = {a: 5, b: 6, c: 5.5, d: 4, e: 5}
    result = Indico::Results.new(data)
    expect(result.sorted).to eql({ b: 6, c: 5.5, a: 5, e: 5, d: 4 })
  end

  it 'knows the most likely result' do
    data = {a: 5, b: 6}
    result = Indico::Results.new(data)
    expect(result.most_likely).to eql(:b)
  end

  it 'knows the least likely result' do
    data = {a: 5, b: 6}
    result = Indico::Results.new(data)
    expect(result.least_likely).to eql(:a)
  end

  it 'knows the values' do
    data = {a: 5, b: 6, c: 5.5, d: 4, e: 5}
    result = Indico::Results.new(data)
    expect(result.values).to eql([ :b, :c, :a, :e, :d])
  end

  it 'knows the probabilities' do
    data = {a: 5, b: 6, c: 5.5, d: 4, e: 5}
    result = Indico::Results.new(data)
    expect(result.probabilities).to eql([6, 5.5, 5, 5, 4])
  end
end
