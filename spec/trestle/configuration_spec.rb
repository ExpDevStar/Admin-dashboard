require 'spec_helper'

describe Trestle::Configuration do
  subject(:config) { Trestle::Configuration.new }

  it "has a site title accessor" do
    config.site_title = "My Site"
    expect(config.site_title).to eq("My Site")
  end

  it "has a default site title" do
    expect(config.site_title).to eq("Trestle Admin")
  end

  it "has a default navigation icon accessor" do
    config.default_navigation_icon = "fa fa-user"
    expect(config.default_navigation_icon).to eq("fa fa-user")
  end

  it "has a default navigation icon" do
    expect(config.default_navigation_icon).to eq("fa fa-arrow-circle-o-right")
  end

  it "has no default menu blocks" do
    expect(config.menus).to eq([])
  end

  describe "#menu" do
    it "adds an unbound navigation block to menus" do
      b = proc {}
      config.menu(&b)

      block = config.menus.first
      expect(block).to be_a(Trestle::Navigation::Block)
      expect(block.block).to eq(b)
    end
  end
end
