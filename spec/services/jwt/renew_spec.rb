require 'rails_helper'

RSpec.describe Jwt::Renew do
  let!(:token) { Jwt::Generate.new(user_id: 1).token }
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }
  let(:jti) { JWT::decode(token, ENV['JWT_SECRET_TOKEN'], false).first['jti'] }
  
  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  context '.revoke!' do
    subject { described_class.new(token).revoke! }

    it 'adds token to jti blacklist' do
      allow(Rails.cache).to receive(:write)
      subject
      expect(Rails.cache).to have_received(:write).with("jwt_jti_denied/#{jti}", true)
    end
  end

  context '.generate!' do
    subject { described_class.new(token).generate! }

    it 'adds token to jti blacklist' do
      allow(Rails.cache).to receive(:write)
      subject
      expect(Rails.cache).to have_received(:write).with("jwt_jti_denied/#{jti}", true)
    end

    it 'returns a valid token' do
      expect{ JWT.decode(subject.token, ENV['JWT_SECRET_KEY']) }.not_to raise_error(JWT::DecodeError)
    end
  end
end
