require 'spec_helper'

describe Trestle::Options do
  subject(:options) { Trestle::Options.new(singular: "foo", array: [1, 2, 3]) }

  it "is a hash" do
    expect(options).to be_a(Hash)
  end

  describe "#merge" do
    it "returns a Trestle::Options instance" do
      expect(options.merge({})).to be_a(Trestle::Options)
    end

    it "overrides singular values" do
      expect(options.merge(singular: "changed")).to eq(Trestle::Options.new(singular: "changed", array: [1, 2, 3]))
    end

    it "appends arrays to array values" do
      expect(options.merge(array: [4, 5, 6])).to eq(Trestle::Options.new(singular: "foo", array: [1, 2, 3, 4, 5, 6]))
    end

    it "appends singular values to array values" do
      expect(options.merge(array: 4)).to eq(Trestle::Options.new(singular: "foo", array: [1, 2, 3, 4]))
    end
  end

  describe "#merge!" do
    it "overrides singular values" do
      options.merge!(singular: "changed")
      expect(options).to eq(Trestle::Options.new(singular: "changed", array: [1, 2, 3]))
    end

    it "appends arrays to array values" do
      options.merge!(array: [4, 5, 6])
      expect(options).to eq(Trestle::Options.new(singular: "foo", array: [1, 2, 3, 4, 5, 6]))
    end

    it "appends singular values to array values" do
      options.merge!(array: 4)
      expect(options).to eq(Trestle::Options.new(singular: "foo", array: [1, 2, 3, 4]))
    end
  end
end
