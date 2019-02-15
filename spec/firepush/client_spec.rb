# frozen_string_literal: true

RSpec.describe Firepush::Client do
  let(:access_token) { "fjadslkdfjlksdjfkas.fdsjfljsakfda.fsakjfalsdfd" }
  let(:project_id)   { "firepush-dev" }

  let(:client) do
    described_class.new(
      access_token: access_token,
      project_id:   project_id,
    )
  end

  describe "#message=" do
    subject { client.message = message }

    context "w/ invalid argument" do
      let(:message) do
        {
          notification: {
            title: "foo",
          },
        }
      end

      it "raises ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end
    end

    context "w/ valid argument" do
      let(:message) do
        {
          notification: {
            title: "foo",
            body: "bar",
          },
          topic: "news_letter",
        }
      end

      it "sets Firepush::Message" do
        subject
        expect(client.message).to be_a(Firepush::Message)
      end
    end
  end

  describe "#push" do
    context "when passing message" do
      before do
        allow_any_instance_of(Net::HTTP).to receive(:post)
      end

      let(:message) do
        {
          topic: "new_wave",
          data: {
            foo: "bar",
          },
        }
      end

      it "sets message before sending" do
        expect(client.message).to be_nil

        client.push(message)
        expect(client.message).to be_a(Firepush::Message)
      end
    end

    context "w/o argument" do
      before do
        allow_any_instance_of(Net::HTTP).to receive(:post)
      end

      it "doesn't raise error" do
        client.message = { token: "xxx", data: { foo: "bar" } }
        client.push
      end
    end

    context "when passing nil message" do
      before do
        allow_any_instance_of(Net::HTTP).to receive(:post)
      end

      it "doesn't override :message" do
        client.message = { token: "xxx", data: { foo: "bar" } }
        client.push(nil)
        expect(client.message).to_not be_nil
      end
    end

    context "w/ invalid attributes" do
      before do
        client.access_token = ""
        client.message = { token: "xxx", data: { foo: "bar" } }
      end

      specify do
        expect { client.push }.to raise_error(Firepush::Client::InvalidAttributes)
      end
    end

    context "w/ valid attributes" do
      before do
        client.message = { token: "xxx", data: { foo: "bar" } }
      end

      it "sends HTTP request to FCM server" do
        expect_any_instance_of(Net::HTTP).to receive(:post)
        client.push
      end
    end
  end

  describe "#valid?" do
    subject { client.valid? }

    context "w/ invalid :access_token" do
      let(:access_token) { nil }

      before do
        client.message = { token: "xxx", data: { foo: "bar" } }
      end

      it { is_expected.to eq false }
    end

    context "w/ invalid :project_id" do
      let(:project_id) { "" }

      before do
        client.message = { token: "xxx", data: { foo: "bar" } }
      end

      it { is_expected.to eq false }
    end

    context "w/o message" do
      it { is_expected.to eq false }
    end

    context "w/ invalid message" do
      before do
        client.message = { token: "xxx", data: { foo: 100 } }
      end

      it { is_expected.to eq false }
    end

    context "w/ valid attributes" do
      before do
        client.message = { token: "xxx", data: { foo: "100" } }
      end

      it { is_expected.to eq true }
    end
  end
end
