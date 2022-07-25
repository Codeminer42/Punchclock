require 'rails_helper'

RSpec.describe Jwt::Renew do
  let!(:token) { Jwt::Generate.new(user_id: 1).token }
  let(:memory_store) { ActiveSupport::Cache.lookup_store(:memory_store) }

  before do
    allow(Rails).to receive(:cache).and_return(memory_store)
    Rails.cache.clear
  end

  context '.revoke!' do
    subject { described_class.new(token).revoke! }

    it 'adds token to jti blacklist' do
      subject
      expect { Jwt::Verify.call(token) }.to raise_error(Jwt::Verify::InvalidError)
    end
  end

  context '.generate!' do
    subject { described_class.new(token).generate! }

    it 'adds token to jti blacklist' do
      subject
      expect { Jwt::Verify.call(token) }.to raise_error(Jwt::Verify::InvalidError)
    end

    it 'returns a valid token' do
      expect(Jwt::Verify.call(subject.token)).to be(1)
    end
  end
end
