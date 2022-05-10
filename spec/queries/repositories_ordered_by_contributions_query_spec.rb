# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RepositoriesOrderedByContributionsQuery do
  describe '.call' do
    subject(:call) { described_class.new.call }

    let!(:repo1) { create(:repository) }
    let!(:repo2) { create(:repository) }
    let!(:repo3) { create(:repository) }

    context 'when repositories have different number of contributions each' do
      let!(:contribution1) { create(:contribution, repository: repo2) }
      let!(:contribution2) { create(:contribution, repository: repo2) }
      let!(:contribution3) { create(:contribution, repository: repo3) }

      it 'returns repositories list ordered by contributions count' do
        expect(call).to eq [[repo2.link, repo2.id], [repo3.link, repo3.id], [repo1.link, repo1.id]]
      end
    end

    context 'when all repositories have the same number of contributions' do
      let!(:contribution1) { create(:contribution, repository: repo1) }
      let!(:contribution3) { create(:contribution, repository: repo3) }
      let!(:contribution2) { create(:contribution, repository: repo2) }

      it 'returns repositories list ordered by id' do
        expect(call).to eq [[repo1.link, repo1.id], [repo2.link, repo2.id], [repo3.link, repo3.id]]
      end
    end
  end
end
