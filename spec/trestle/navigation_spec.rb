require 'spec_helper'

describe Trestle::Navigation do
  subject(:navigation) { Trestle::Navigation.new(blocks) }
  let(:blocks) { [block] }

  describe "#items" do
    let(:blocks) do
      [
        Trestle::Navigation::Block.new { item :test },
        Trestle::Navigation::Block.new { item :another, "/path", icon: "fa fa-plus" },
      ]
    end

    it "returns all available menu items" do
      expect(navigation.items).to eq([
        Trestle::Navigation::Item.new(:test),
        Trestle::Navigation::Item.new(:another, "/path", icon: "fa fa-plus")
      ])
    end
  end

  describe "#by_group" do
    let(:block) do
      Trestle::Navigation::Block.new do
        item :ungrouped

        group :group1, priority: 10 do
          item :group1_item1
        end

        group :group2, priority: 5 do
          item :group2_item1, nil, priority: 2
          item :group2_item2, nil, priority: 1
          item :agroup2_item3, nil, priority: 2
        end

        group :agroup3, priority: 5 do
          item :group3_item1
        end
      end
    end

    let(:result) { navigation.by_group }

    it "returns ungrouped items first" do
      expect(result.keys.first).to eq(Trestle::Navigation::NullGroup.new)
      expect(result.values.first).to eq([Trestle::Navigation::Item.new(:ungrouped)])
    end

    it "sorts groups by priority" do
      group1 = Trestle::Navigation::Group.new(:group1)
      group2 = Trestle::Navigation::Group.new(:group2)

      expect(result.keys.index(group1)).to be > result.keys.index(group2)
    end

    it "sorts groups with equal priority alphabetically" do
      group2 = Trestle::Navigation::Group.new(:group2)
      group3 = Trestle::Navigation::Group.new(:agroup3)

      expect(result.keys.index(group2)).to be > result.keys.index(group3)
    end

    it "sorts items by priority" do
      group = Trestle::Navigation::Group.new(:group2)
      items = result[group]

      item1 = items.find { |i| i.name == :group2_item1 }
      item2 = items.find { |i| i.name == :group2_item2 }

      expect(items.index(item1)).to be > items.index(item2)
    end

    it "sorts items with equal priority alphabetically" do
      group = Trestle::Navigation::Group.new(:group2)
      items = result[group]

      item1 = items.find { |i| i.name == :group2_item1 }
      item3 = items.find { |i| i.name == :agroup2_item3 }

      expect(items.index(item1)).to be > items.index(item3)
    end
  end

  describe "#each" do
    let(:block) do
      Trestle::Navigation::Block.new do
        item :ungrouped

        group :group do
          item :item1
          item :item2
        end
      end
    end

    it "yields each navigation group and its items" do
      group = Trestle::Navigation::Group.new(:group)

      expect { |b| navigation.each(&b) }.to yield_successive_args(
        [Trestle::Navigation::NullGroup.new, [Trestle::Navigation::Item.new(:ungrouped)]],
        [group, [Trestle::Navigation::Item.new(:item1), Trestle::Navigation::Item.new(:item2)]]
      )
    end
  end
end
