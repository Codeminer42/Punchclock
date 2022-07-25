require 'rails_helper'

RSpec.describe Jwt::Generate do
  let(:generated_jwt) { described_class.new(user_id: 1) }

  it 'has correct payload' do
    expect(generated_jwt.payload).to include(:exp, :sub, :env, :jti)
  end

  it 'aways returns different tokens' do
    expect(generated_jwt.token).not_to eq(described_class.new(user_id: 1).token)
  end

  it 'returns correct parse to string' do
    expect(generated_jwt.to_s).to eq(generated_jwt.token)
  end

  it 'returns correct parse to hash' do
    expect(generated_jwt.to_h).to eq({ access_token: generated_jwt.token })
  end

  it 'returns correct parse to json' do
    expect(generated_jwt.to_json).to eq({ access_token: generated_jwt.token }.to_json)
  end

  describe '.token' do
    let(:payload) { generated_jwt.payload }

    it 'calls JWT::encode' do
      allow(JWT).to receive(:encode)
      generated_jwt.token
      expect(JWT).to have_received(:encode).with(payload, ENV['JWT_SECRET_KEY'])
    end

    it 'returns a valid token' do
      expect { JWT.decode(generated_jwt.token, ENV['JWT_SECRET_KEY']) }.not_to raise_error
    end

    it 'contains correct data' do
      decoded_token = JWT.decode(generated_jwt.token, ENV['JWT_SECRET_KEY'])
      token_payload = decoded_token[0].symbolize_keys!
      expect(token_payload).to eq(payload)
    end
  end
end
