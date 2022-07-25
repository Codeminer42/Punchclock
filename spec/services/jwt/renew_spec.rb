require 'rails_helper'

RSpec.describe Jwt::Renew do
  let!(:token) { Jwt::Generate.new(user_id: 1).token }
  let(:jti) { JWT.decode(token, ENV['JWT_SECRET_TOKEN'], false).first['jti'] }
  subject(:jwt_renew) { described_class.new(token) }

  before do
    memory_store = ActiveSupport::Cache.lookup_store(:memory_store)
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  context '.revoke!' do
    it 'adds token to jti blacklist' do
      allow(Rails.cache).to receive(:write)
      jwt_renew.revoke!
      expect(Rails.cache).to have_received(:write).with("jwt_jti_denied/#{jti}", true)
    end
  end

  context '.generate!' do
    it 'adds token to jti blacklist' do
      allow(Rails.cache).to receive(:write)
      jwt_renew.generate!
      expect(Rails.cache).to have_received(:write).with("jwt_jti_denied/#{jti}", true)
    end

    it 'returns a valid token' do
      expect { JWT.decode(jwt_renew.generate!.token, ENV['JWT_SECRET_KEY']) }.not_to raise_error
    end
  end
end
