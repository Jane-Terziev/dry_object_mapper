# frozen_string_literal: true

require "spec_helper"
require "json"

RSpec.describe DryObjectMapper::Mapper do
  let(:date) { Date.today }
  let(:datetime) { DateTime.now }

  let(:object) do
    OpenStruct.new(
      string: "string",
      integer: 1,
      float: 1.0,
      date: date,
      datetime: datetime,
      any: 'any_type',
      nested_array_of_objects: [
        OpenStruct.new(
          string: "string",
          integer: 1,
          float: 1.0,
          date: date,
          datetime: datetime,
          any: 'any_type'
        )
      ],
      nested_object: OpenStruct.new(
        string: "string",
        integer: 1,
        float: 1.0,
        date: date,
        datetime: datetime,
        any: 'any_type'
      ),
      empty_nested_object: nil
    )
  end

  let(:dto) do
    nested_object_struct = Class.new(Dry::Struct) do
      attribute :string, DryObjectMapper::Types::String
      attribute :integer, DryObjectMapper::Types::Integer
      attribute :float, DryObjectMapper::Types::Float
      attribute :date, DryObjectMapper::Types::Date
      attribute :datetime, DryObjectMapper::Types::DateTime
      attribute :any, DryObjectMapper::Types::Any
    end

    Class.new(Dry::Struct) do
      attribute :string, DryObjectMapper::Types::String
      attribute :integer, DryObjectMapper::Types::Integer
      attribute :float, DryObjectMapper::Types::Float
      attribute :date, DryObjectMapper::Types::Date
      attribute :datetime, DryObjectMapper::Types::DateTime
      attribute :any, DryObjectMapper::Types::Any
      attribute :nested_array_of_objects, DryObjectMapper::Types::Array.of(nested_object_struct)
      attribute :nested_object, nested_object_struct
      attribute? :empty_nested_object, nested_object_struct.optional
    end
  end

  let(:expected_result) do
    {
      "string": "string",
      "integer": 1,
      "float": 1.0,
      "date": date,
      "datetime": datetime,
      "any": 'any_type',
      "nested_array_of_objects": [
        {
          "string": "string",
          "integer": 1,
          "float": 1.0,
          "date": date,
          "datetime": datetime,
          "any": 'any_type'
        }
      ],
      "nested_object": {
        "string": "string",
        "integer": 1,
        "float": 1.0,
        "date": date,
        "datetime": datetime,
        "any": 'any_type'
      },
      "empty_nested_object": nil
    }
  end

  describe "when passing an array of objects" do
    context "and all of the fields are present" do
      it "should map all of the object attributes to the DTO" do
        result = described_class.call([object], dto)
        expect(result.map(&:to_h)).to eq([object].map { |it| deep_open_struct_to_hash(it) })
      end
    end
  end

  describe "when passing a single object" do
    context "and all the fields are present" do
      it "should map all of the object attributes to the DTO" do
        result = described_class.call(object, dto)
        expect(result.to_h).to eq(expected_result)
      end
    end
  end
end
