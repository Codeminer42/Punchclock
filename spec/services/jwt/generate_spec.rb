require 'rails_helper'

RSpec.describe Jwt::Generate do
  context '.initialize' do
    #mostrar que ele sempre gera um jti diferente
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
    subject { class_instance.token }
    let(:class_instance) { described_class.new(user_id: 1) }
    let(:payload) { class_instance.payload }
    let(:decode_token) { JWT.decode(subject, ENV['JWT_SECRET_KEY']) }
    
    it 'calls JWT::encode' do
      allow(JWT).to receive(:encode).and_return('expected_token')
      expect(subject).to eq('expected_token')
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
