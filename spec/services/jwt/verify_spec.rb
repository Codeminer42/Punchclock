require 'rails_helper'

RSpec.describe Jwt::Verify do
  
  describe '.call' do
    context 'when token is not expired' do
      let(:valid_token) { Jwt::Generate.new(user_id: 1, expire_at: 1.week.from_now).token }
      it 'does not raise error' do
        expect { described_class.call(valid_token) }.not_to raise_error
      end
      
      it 'returns user_id' do
        expect(described_class.call(valid_token)).to eq(1)
      end
    end
    
    context 'when token is expired' do
      let(:expired_token) { Jwt::Generate.new(user_id: 1, expire_at: 2.week.ago).token }
      it 'raises an InvalidError' do
        expect { described_class.call(expired_token) }.to raise_error(Jwt::Verify::InvalidError)
      end
    end

    context 'when token was generated on another Rails.env' do
      let!(:token) { Jwt::Generate.new(user_id: 1, expire_at: 1.week.from_now).token }

      it 'raises an InvalidError' do
        allow(Rails).to receive(:env).and_return('development'.inquiry)

        expect { described_class.call(token) }.to raise_error(Jwt::Verify::InvalidError)
      end
    end
  end
end
