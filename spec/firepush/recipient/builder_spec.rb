# frozen_string_literal: true

RSpec.describe Firepush::Recipient::Builder do
  describe ".build" do
    subject { described_class.build(args) }

    context "w/ :topic, :token, and :condition" do
      let(:args) do
        {
          topic: "news",
          token: "xxx",
          condition: "'news' in topics || 'letters' in topics",
        }
      end

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "w/ :topic and :token" do
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

    context "w/ :topic and :condition" do
      let(:args) do
        {
          topic: "news",
          condition: "'news' in topics || 'letters' in topics",
        }
      end

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "w/o :topic, :token, nor :condition" do
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

    context "w/ :condition" do
      let(:args) do
        { condition: "'TopicA' in topics && ('TopicB' in topics || 'TopicC' in topics)" }
      end

      it { is_expected.to be_a(Firepush::Recipient::Condition) }
    end
  end
end
