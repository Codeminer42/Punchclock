# frozen_string_literal: true

require 'rails_helper'

describe 'Repositories list', type: :feature do
  let!(:authed_user) { create_logged_in_user }

  context 'without filter' do
    let!(:repository) { create(:repository).decorate }
    let!(:second_repository) { create(:repository).decorate }

    before do
      visit repositories_path
    end

    it 'has the right count of 25 repositories' do
      create_list(:repository, 26)

      visit repositories_path

      expect(page).to have_css('#repository-card', count: 25)
    end

    it 'have all links for repositories' do
      expect(page).to have_link(repository.link, href: repository.link) &
                      have_link(second_repository.link, href: second_repository.link)
    end

    it 'have all languages for repositories' do
      repository.languages.each do |language|
        expect(page).to have_css('#language-tag', text: language)
      end

      second_repository.languages.each do |language|
        expect(page).to have_css('#language-tag', text: language)
      end
    end

    it 'has all descriptions for repositories' do
      expect(page).to have_text(repository.description) &
                      have_text(second_repository.description)
    end
  end

  context 'when filtering by languages' do
    let!(:repository) { create(:repository, language: 'javascript,ruby,python').decorate }
    let!(:second_repository) { create(:repository, language: 'Shell,react,python').decorate }

    before do
      visit repositories_path
    end

    it 'have the language javascript' do
      fill_in 'search-input-field', with: 'javascript'
      find('#filter-button').click

      repository.languages.each do |language|
        expect(page).to have_css('#language-tag', text: language)
      end

      second_repository.languages.each do |language|
        expect(page).not_to have_css('#language-tag', text: language)
      end
    end

    it 'not have any repository with Go' do
      fill_in 'search-input-field', with: 'go'
      find('#filter-button').click

      expect(page).not_to have_text(repository.languages)
      expect(page).not_to have_text(second_repository.languages)
    end

    it 'have two repositories with python' do
      fill_in 'search-input-field', with: 'python'
      find('#filter-button').click

      expect(page).to have_text('python')
      expect(page).to have_css('#repository-card', count: 2)
    end
  end

  context 'when the repository has no issues and stars' do
    let!(:repository) { create(:repository).decorate }

    before do
      visit repositories_path
    end

    it 'have all issues for repositories' do
      expect(page).not_to have_css('#issues-tag')
    end

    it 'have all stars for repositories' do
      expect(page).not_to have_css('#stars-tag')
    end
  end

  context 'when the repository has issues' do
    let!(:repository) { create(:repository, issues:).decorate }

    before do
      visit repositories_path
    end

    context 'when issues are greater than 1000' do
      let(:issues) { 5566 }
      it 'returns the number of issues abbreviated to thousands' do
        expect(page).to have_css('#issues-tag', text: '5.6K')
      end
    end

    context 'when issues are less than 1000' do
      let(:issues) { 885 }
      it 'returns the number of issues without abbreviations' do
        expect(page).to have_css('#issues-tag', text: repository.issues)
      end
    end
  end

  context 'when the repository has stars' do
    let!(:repository) { create(:repository, stars:).decorate }

    before do
      visit repositories_path
    end

    context 'when stars are greater than 1000' do
      let(:stars) { 1500 }
      it 'returns the number of stars abbreviated to thousands' do
        expect(page).to have_css('#stars-tag', text: '1.5K')
      end
    end

    context 'when stars are less than 1000' do
      let(:stars) { 644 }
      it 'returns the number of stars without abbreviations' do
        expect(page).to have_css('#stars-tag', text: repository.stars)
      end
    end
  end
end
