require 'spec_helper'

describe Trestle::Admin do
  before(:each) do
    class TestAdmin < Trestle::Admin; end
  end

  let(:subject) { TestAdmin }

  it "has an admin name" do
    expect(subject.admin_name).to eq("test")
  end

  it "has a route name" do
    expect(subject.route_name).to eq("test_admin")
  end

  it "has a controller path" do
    expect(subject.controller_path).to eq("admin/test")
  end

  it "has a controller namespace" do
    expect(subject.controller_namespace).to eq("test_admin/admin")
  end

  it "has a menu accessor" do
    block = Trestle::Navigation::Block.new

    subject.menu = block
    expect(subject.menu).to eq(block)
  end

  it "has an options accessor" do
    options = { option: "custom" }

    subject.options = options
    expect(subject.options).to eq(options)
  end

  context "scoped within a module" do
    before(:each) do
      module Scoped
        class TestAdmin < Trestle::Admin; end
      end
    end

    let(:subject) { Scoped::TestAdmin }

    it "has an admin name" do
      expect(subject.admin_name).to eq("scoped/test")
    end

    it "has a route name" do
      expect(subject.route_name).to eq("scoped_test_admin")
    end

    it "has a controller path" do
      expect(subject.controller_path).to eq("admin/scoped/test")
    end

    it "has a controller namespace" do
      expect(subject.controller_namespace).to eq("scoped/test_admin/admin")
    end
  end
end
