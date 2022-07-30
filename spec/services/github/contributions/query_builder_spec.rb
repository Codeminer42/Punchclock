require 'rails_helper'

RSpec.describe Github::Contributions::QueryBuilder do
  include EnvHelper

  describe '#build_query_string' do
    subject { described_class.build_query_string(authors_query, repositories_query) } 
    let(:time_now) { Time.rfc3339('2022-06-06T00:00:00-03:00') }
    let(:authors_query) { 'author:user1 author:user2' }
    let(:repositories_query) { 'repo:owner1/name1 repo:owner2/name2' }

    before do
      allow(Time).to receive(:now).and_return(time_now)
    end

    context 'when the DAYS_TO_SEARCH_CONTRIBUTIONS env var is not set' do
      before do
        ENV['DAYS_TO_SEARCH_CONTRIBUTIONS'] = nil
      end

      it { is_expected.to eq "created:2022-06-05 is:pr author:user1 author:user2 repo:owner1/name1 repo:owner2/name2" }
    end

    context 'when the DAYS_TO_SEARCH_CONTRIBUTIONS env var is set' do
      before do
        ENV['DAYS_TO_SEARCH_CONTRIBUTIONS'] = 2.to_s
      end

      it { is_expected.to eq "created:2022-06-04 is:pr author:user1 author:user2 repo:owner1/name1 repo:owner2/name2" }
    end
  end
end
