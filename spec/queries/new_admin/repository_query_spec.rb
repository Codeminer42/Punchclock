# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::RepositoryQuery do
  context 'when searching for all repositories from certain languages' do
    let!(:ruby_lang_repo) { create(:repository, { language: 'Ruby' }) }
    let!(:c_lang_repos) { create_list(:repository, 2, { language: 'C' }) }
    let(:filter_params) do
      {
        repository_name_search: nil,
        languages: ['C']
      }
    end

    let(:expected_attributes) do
      c_lang_repos.sort_by!(&:link)
    end

    subject { described_class.new(**filter_params).call }

    it 'returns all repositories from those languages' do
      expect(subject).to eq(expected_attributes)
    end
  end

  context 'when searching for a specific repositories by its partial or total name' do
    let!(:requested_repo) { create(:repository, { link: 'http://github.com/flutter/flutter' }) }
    let!(:js_lang_repo) { create(:repository, { link: 'https://github.com/jquense/yup' }) }
    let(:filter_params) do
      {
        repository_name_search: 'flutter',
        languages: []
      }
    end

    subject { described_class.new(**filter_params).call }

    it 'returns all repositories that matches the search' do
      expect(subject).to eq([requested_repo])
    end
  end

  context 'when searching by specific repositories by its partial or total name and its language' do
    let!(:ruby_repo_1) { create(:repository, { language: 'Ruby', link: 'https://github.com/ruby/ruby' }) }
    let!(:ruby_repo_2) { create(:repository, { language: 'Ruby', link: 'https://github.com/ruby-i18n/i18n' }) }
    let(:filter_params) do
      {
        repository_name_search: 'ruby',
        languages: ['Ruby']
      }
    end
    let(:expected_attributes) do
      [ruby_repo_1, ruby_repo_2].sort_by!(&:link)
    end

    subject { described_class.new(**filter_params).call }

    it 'returns all repositories that matches the search' do
      expect(subject).to eq(expected_attributes)
    end
  end

  context 'when filter options are blank' do
    let!(:repositories_list) { create_list(:repository, 2) }
    let(:filter_params) do
      {
        repository_name_search: nil,
        languages: []
      }
    end
    let(:expected_attributes) do
      repositories_list.sort_by!(&:link)
    end

    subject { described_class.new(**filter_params).call }

    it 'returns all repositories' do
      expect(subject).to eq(expected_attributes)
    end
  end
end
