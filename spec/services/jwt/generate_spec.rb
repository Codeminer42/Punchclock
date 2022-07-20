require 'rails_helper'

RSpec.describe Jwt::Generate do
  before do
    @expected_token = "eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2NDE2MTA4MDAsInN1YiI6MSwiZW52IjoidGVzdCIsImp0aSI6InZhbGlkX3V1aWQifQ.yOFK_juAoBONyGYbf9f1PZ5zXcNtTiDptCEMwxcmOGA"
    allow(SecureRandom).to receive(:uuid).and_return('valid_uuid')
    travel_to Time.local(2022)
  end

  context '.initialize' do
    subject { described_class.new(user_id: 1) }

    it 'has correct payload' do
      expect(subject.payload).to eq({ exp: 1.week.from_now.to_i,
                                      sub: 1,
                                      env: Rails.env,
                                      jti: 'valid_uuid' })
    end

    it 'returns correct parse to string' do
      expect(subject.to_s).to eq(@expected_token)
    end

    it 'returns correct parse to hash' do
      expect(subject.to_h).to eq({ access_token: @expected_token })
    end

    it 'returns correct parse to json' do
      expect(subject.to_json(options: 'mock_option')).to eq({ access_token: @expected_token }.to_json)
    end
  end

  describe '.token' do
    subject { described_class.new(user_id: 1).token }
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
