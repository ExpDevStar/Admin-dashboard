require 'spec_helper'

describe Trestle::Table::Builder do
  it "creates a Table with the given options" do
    table = Trestle::Table::Builder.build(class: "my-table")

    expect(table).to be_a(Trestle::Table)
    expect(table.classes).to eq("my-table")
  end

  describe "#column" do
    it "adds a column to the table" do
      block = Proc.new {}
      table = Trestle::Table::Builder.build do
        column :my_field, class: "custom-class", &block
      end

      column = table.columns[0]

      expect(column.field).to eq(:my_field)
      expect(column.options).to eq({ class: "custom-class" })
      expect(column.block).to eq(block)
    end
  end

  describe "#actions" do
    it "adds an actions column to the table" do
      block = Proc.new {}
      table = Trestle::Table::Builder.build do
        actions &block
      end

      column = table.columns[0]

      expect(column).to be_a(Trestle::Table::ActionsColumn)
      expect(column.block).to eq(block)
    end
  end
end
