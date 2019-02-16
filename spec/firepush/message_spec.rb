# frozen_string_literal: true

RSpec.describe Firepush::Message do
  let(:message) { described_class.new(msg) }

  describe ".new" do
    context "w/ regular options" do
      let(:msg) do
        {
          topic: "news",
          notification: {
            title: "Hello",
            body: "world",
          },
        }
      end

      it "sets attributes" do
        expect(message.recipient.key).to eq :topic
        expect(message.recipient.value).to eq "news"
        expect(message.message_type.key).to eq :notification
        expect(message.message_type.value).to eq(title: "Hello", body: "world")
        expect(message.extra).to eq({})
      end
    end

    context "w/ extra options" do
      let(:msg) do
        {
          topic: "news",
          notification: {
            title: "Hello",
            body: "world",
          },
          android: {
            ttl: "86400s",
            notification: {
              click_action: "OPEN_ACTIVITY_1",
            },
          },
          apns: {
            headers: {
              "apns-priority" => "5",
            },
            payload: {
              aps: {
                category: "NEW_MESSAGE_CATEGORY",
              }
            },
          },
        }
      end

      it "sets as :extra" do
        expect(message.extra.dig(:android, :ttl)).to eq "86400s"
        expect(message.extra.dig(:android, :notification, :click_action)).to eq "OPEN_ACTIVITY_1"
        expect(message.extra.dig(:apns, :headers, "apns-priority")).to eq "5"
        expect(message.extra.dig(:apns, :payload, :aps, :category)).to eq "NEW_MESSAGE_CATEGORY"
      end
    end
  end

  describe "#to_json" do
    subject(:json) { message.to_json }

    context "w/ :topic and :notification" do
      let(:msg) do
        {
          topic: "news",
          notification: {
            title: "Hello",
            body: "world"
          },
        }
      end

      it "returns JSON string" do
        is_expected.to be_a(String)
        hash = JSON.parse(json)
        expect(hash["message"]["topic"]).to eq "news"
        expect(hash["message"]["notification"]["title"]).to eq "Hello"
        expect(hash["message"]["notification"]["body"]).to eq "world"
      end
    end

    context "w/ :topic and :data" do
      let(:msg) do
        {
          topic: "news",
          data: {
            foo: "a message",
            bar: "500"
          },
        }
      end

      it "returns JSON string" do
        is_expected.to be_a(String)
        hash = JSON.parse(json)
        expect(hash["message"]["topic"]).to eq "news"
        expect(hash["message"]["data"]["foo"]).to eq "a message"
        expect(hash["message"]["data"]["bar"]).to eq "500"
      end
    end

    context "w/ :token and :notification" do
      let(:msg) do
        {
          token: "xxx",
          notification: {
            title: "Hello",
            body: "world"
          },
        }
      end

      it "returns JSON string" do
        is_expected.to be_a(String)
        hash = JSON.parse(json)
        expect(hash["message"]["token"]).to eq "xxx"
        expect(hash["message"]["notification"]["title"]).to eq "Hello"
        expect(hash["message"]["notification"]["body"]).to eq "world"
      end
    end

    context "w/ :token and :data" do
      let(:msg) do
        {
          token: "xxx",
          data: {
            bob: "bbb",
            alice: "aaa"
          },
        }
      end

      it "returns JSON string" do
        is_expected.to be_a(String)
        hash = JSON.parse(json)
        expect(hash["message"]["token"]).to eq "xxx"
        expect(hash["message"]["data"]["bob"]).to eq "bbb"
        expect(hash["message"]["data"]["alice"]).to eq "aaa"
      end
    end

    context "w/ :extra" do
      let(:msg) do
        {
          topic: "news",
          notification: {
            title: "Hello",
            body: "world",
          },
          android: {
            ttl: "86400s",
            notification: {
              click_action: "OPEN_ACTIVITY_1",
            },
          },
          apns: {
            headers: {
              "apns-priority" => "5",
            },
            payload: {
              aps: {
                category: "NEW_MESSAGE_CATEGORY",
              }
            },
          },
        }
      end

      it "returns JSON string" do
        is_expected.to be_a(String)
        hash = JSON.parse(json)
        expect(hash["message"]["topic"]).to eq "news"
        expect(hash["message"]["notification"]["title"]).to eq "Hello"
        expect(hash["message"]["notification"]["body"]).to eq "world"
        expect(hash["message"]["android"]["ttl"]).to eq "86400s"
        expect(hash["message"]["android"]["notification"]["click_action"]).to eq "OPEN_ACTIVITY_1"
        expect(hash["message"]["apns"]["headers"]["apns-priority"]).to eq "5"
        expect(hash["message"]["apns"]["payload"]["aps"]["category"]).to eq "NEW_MESSAGE_CATEGORY"
      end
    end
  end

  describe "#valid?" do
    subject { message.valid? }

    context "w/ :topic and :notification" do
      let(:msg) do
        {
          topic: topic,
          notification: notification,
        }
      end

      context "and :topic is invalid" do
        let(:topic) { "" }
        let(:notification) { { title: "abc", body: "cde" } }

        it { is_expected.to eq false }
      end

      context "and notification.title is invalid" do
        let(:topic) { "abc" }
        let(:notification) { { title: "", body: "cde" } }

        it { is_expected.to eq false }
      end

      context "and notification.body is invalid" do
        let(:topic) { "abc" }
        let(:notification) { { title: "cde", body: nil } }

        it { is_expected.to eq false }
      end

      context "and all valid" do
        let(:topic) { "abc" }
        let(:notification) { { title: "cde", body: "def" } }

        it { is_expected.to eq true }
      end
    end

    context "w/ :topic and :data" do
      let(:msg) do
        {
          topic: topic,
          data: data,
        }
      end

      context "and invalid :topic" do
        let(:topic) { nil }
        let(:data) { { foo: "foo" } }

        it { is_expected.to eq false }
      end

      context "and invalid :data" do
        let(:topic) { "hot-spring" }
        let(:data) { { foo: "foo", bar: 100 } }

        it { is_expected.to eq false }
      end

      context "and all valid" do
        let(:topic) { "news" }
        let(:data) { { foo: "foo", bar: "1" } }

        it { is_expected.to eq true }
      end
    end

    context "w/ :token and :notification" do
      let(:msg) do
        {
          token: token,
          notification: notification,
        }
      end

      context "and invalid :token" do
        let(:token) { "" }
        let(:notification) { { title: "a", body: "b" } }

        it { is_expected.to eq false }
      end

      context "and invalid notification.title" do
        let(:token) { "xxx" }
        let(:notification) { { title: nil, body: "world" } }

        it { is_expected.to eq false }
      end

      context "and invalid notification.body" do
        let(:token) { "yyy"  }
        let(:notification) { { title: "Hello", body: "" } }

        it { is_expected.to eq false }
      end

      context "and all valid" do
        let(:token) { "zzz" }
        let(:notification) { { title: "aaa", body: "bbb" } }

        it { is_expected.to eq true }
      end
    end

    context "w/ :token and :data" do
      let(:msg) do
        {
          token: token,
          data: data,
        }
      end

      context "and invalid :token" do
        let(:token) { nil }
        let(:data) { { foo: "book" }  }

        it { is_expected.to eq false }
      end

      context "and invalid :data" do
        let(:token) { "abc" }
        let(:data) { { foo: nil, bar: "bar", buz: {} }  }

        it { is_expected.to eq false }
      end

      context "and all valid" do
        let(:token) { "my-token" }
        let(:data) { { foo: "foo", bar: "bar", buz: "buz" }  }

        it { is_expected.to eq true }
      end
    end
  end
end
