# frozen_string_literal: true

RSpec.describe Firepush::Recipient::Builder do
  describe ".build" do
    subject { described_class.build(args) }

    context "w/ both :topic and :token" do
      let(:args) do
        {
          topic: "news",
          token: "xxx",
        }
      end

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "w/o :topic nor :token" do
      let(:args) { { buz: "fooo!" } }

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "w/ :topic" do
      let(:args) { { topic: "news" } }

      it { is_expected.to be_a(Firepush::Recipient::Topic) }
    end

    context "w/ :token" do
      let(:args) { { token: "xxx" } }

      it { is_expected.to be_a(Firepush::Recipient::Token) }
    end
  end
end
