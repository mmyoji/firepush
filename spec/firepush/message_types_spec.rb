# frozen_string_literal: true

RSpec.describe Firepush::MessageTypes do
  describe ".new" do
    subject(:types) { described_class.new(args) }

    context "w/ valid :notification and :data" do
      let(:args) do
        {
          notification: {
            title: "Hello",
            body: "world",
          },
          data: {
            foo: "foo",
          },
        }
      end

      it "sets @types" do
        expect(types.types.count).to eq 2
        expect(types.types.any? { |t| t.key == :notification }).to eq true
        expect(types.types.any? { |t| t.key == :data }).to eq true
      end
    end

    context "w/ :notification" do
      let(:args) do
        {
          notification: {
            title: "Hello",
            body: "world",
          },
        }
      end

      it "sets @types" do
        expect(types.types.count).to eq 1
        expect(types.types.any? { |t| t.key == :notification }).to eq true
      end
    end
  end
end
