require 'rails_helper'

RSpec.describe Jwt::Generate do
  context '.initialize' do
    subject { described_class.new(user_id: 1) }

    it 'has correct payload' do
      expect(subject.payload).to include(:exp, :sub, :env, :jti)
    end

    it 'aways returns different tokens' do
      expect(subject.token).not_to eq(described_class.new(user_id: 1).token)
    end

    it 'returns correct parse to string' do
      expect(subject.to_s).to eq(subject.token)
    end

    it 'returns correct parse to hash' do
      expect(subject.to_h).to eq({ access_token: subject.token })
    end

    it 'returns correct parse to json' do
      expect(subject.to_json).to eq({ access_token: subject.token }.to_json)
    end
  end

  describe '.token' do
    subject { described_class.new(user_id: 1) }
    let(:payload) { subject.payload }
    let(:decode_token) { JWT.decode(subject.token, ENV['JWT_SECRET_KEY']) }

    it 'calls JWT::encode' do
      allow(JWT).to receive(:encode)
      subject.token
      expect(JWT).to have_received(:encode).with(payload, ENV['JWT_SECRET_KEY'])
    end

    it 'returns a valid token' do
      expect { decode_token }.not_to raise_error(JWT::DecodeError)
    end

    it 'contains correct data' do
      expect(decode_token[0].symbolize_keys!).to eq(payload)
    end
  end
end
