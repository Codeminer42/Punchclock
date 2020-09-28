# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::SearchContribution, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '.call' do
    let(:company) { create(:company) }
    subject { described_class.call(company.id) }

    context 'when there are repositories on database' do
      let!(:user) { create(:user, github: 'brunnohenrique', company: company) }

      context 'when there are contributions', vcr: true do
        let!(:repository) { create(:repository, link: 'https://github.com/forem/forem', company: company) }

        it 'return the attributes for contribution' do
          expect(subject.first).to have_attributes(
            profile: 'brunnohenrique',
            link: 'https://github.com/forem/forem/pull/10384'
          )
        end
      end

      context 'when there are no contributions for a given repository', vcr: true do
        let!(:repository) { create(:repository, link: 'https://github.com/ruby/ruby', company: company) }

        it 'return no one contribution' do
          is_expected.to be_empty
        end
      end
    end

    context 'when there are no repositories on database' do
      let!(:user) { create(:user, github: 'brunnohenrique', company: company) }

      it 'return no one contribution' do
        is_expected.to be_empty
      end
    end

    context 'when there are no users present' do
      let!(:repository) { create(:repository, link: 'https://github.com/ruby/ruby', company: company) }

      it 'return no one contribution' do
        is_expected.to be_empty
      end
    end
  end
end
