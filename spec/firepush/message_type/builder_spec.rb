# frozen_string_literal: true

RSpec.describe Firepush::MessageType::Builder do
  describe ".build" do
    subject { described_class.build(args) }

    context "w/ both :notification and :data" do
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

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "w/o :notification nor :data" do
      let(:args) { { foo: "bar" } }

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "w/ invalid :notification" do
      let(:args) do
        {
          notification: {
            title: "Hello",
          },
        }
      end

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "w/ valid :notification" do
      let(:args) do
        {
          notification: {
            title: "Hello",
            body: "world",
          },
        }
      end

      it { is_expected.to be_a(Firepush::MessageType::Notification) }
    end

    context "w/ valid :data" do
      let(:args) do
        {
          data: {
            foo: "100",
            bar: "buz",
          },
        }
      end

      it { is_expected.to be_a(Firepush::MessageType::Data) }
    end
  end
end
