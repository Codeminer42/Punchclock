require 'rails_helper'

RSpec.describe Github::Contributions::QueryBuilder do
  include EnvHelper

  describe '#build_query_string' do
    subject { described_class.build_query_string(authors_query, repositories_query) } 

    let(:authors_query) { 'author:user1 author:user2' }
    let(:repositories_query) { 'repo:owner1/name1 repo:owner2/name2' }

    context 'when the DAYS_TO_SEARCH_CONTRIBUTIONS env var is not set' do
      let(:date_to_search) { 1.day.ago.strftime('%Y-%m-%d') }

      it { is_expected.to eq "created:#{date_to_search} is:pr author:user1 author:user2 repo:owner1/name1 repo:owner2/name2" }
    end

    context 'when the DAYS_TO_SEARCH_CONTRIBUTIONS env var is set' do
      let(:date_to_search) { 2.day.ago.strftime('%Y-%m-%d') }

      before do
        ENV['DAYS_TO_SEARCH_CONTRIBUTIONS'] = 2.to_s
      end

      it { is_expected.to eq "created:#{date_to_search} is:pr author:user1 author:user2 repo:owner1/name1 repo:owner2/name2" }
    end
  end
end
