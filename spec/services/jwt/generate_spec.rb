require 'rails_helper'

RSpec.describe Jwt::Generate do
  before do
    allow(SecureRandom).to receive(:uuid).and_return('valid_uuid')
    @expected_token = "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDE2MTA4MDAsInN1YiI6MSwiZW52IjoidGVzdCIsImp0aSI6InZhbGlkX3V1aWQifQ.yOFK_juAoBONyGYbf9f1PZ5zXcNtTiDptCEMwxcmOGA"
  end

  context '.initialize' do
    #mostrar que ele sempre gera um jti diferente
    subject { described_class.new(user_id: 1) }

    it 'has correct payload' do
      expect(subject.payload).to include('exp', 'sub', 'env', 'jti')
    end

    it 'returns correct parse to string' do
      expect(subject.to_s).to eq(@expected_token)
    end

    it 'returns correct parse to hash' do
      expect(subject.to_h).to eq({ access_token: @expected_token })
    end

    it 'returns correct parse to json' do
      expect(subject.to_json).to eq({ access_token: @expected_token }.to_json)
    end
  end

  describe '.token' do
    subject { described_class.new(user_id: 1).token }

    it 'calls JWT::encode' do
      #exprect encode to be called
    end

    let(:decode_token) { JWT.decode(subject, ENV['JWT_SECRET_KEY']) }

    it 'returns a valid token' do
      expect { decode_token }.not_to raise_error(JWT::DecodeError)
    end

    it 'contains correct data' do
      decoded_token = decode_token
      expect(decode_token).to eq([{'env'=>Rails.env,
                                   'exp'=>1.week.from_now.to_i,
                                   'jti'=>'valid_uuid',
                                   'sub'=>1},
                                   {'alg'=>'HS256'}])
    end
  end
end
