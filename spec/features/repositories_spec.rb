require 'rails_helper'

feature 'Repositories list' do
  let!(:authed_user) { create_logged_in_user }

  context 'without filter' do
    
    let!(:repository) { create(:repository, company_id: authed_user.company_id).decorate }
    let!(:second_repository) { create(:repository, company_id: authed_user.company_id).decorate }
  
    before do
      visit repositories_path
    end
  
    it 'has the right count of repositories' do
      expect(page).to have_css('.list-group .list-group-item', :count => 2)
    end
  
    it 'have all links for repositories' do
      expect(page).to have_link(repository.link, href: repository.link) &
                      have_link(second_repository.link, href: second_repository.link)
    end
  
    it 'have all languages for repositories' do
      expect(page).to have_text(repository.languages) &
                      have_text(second_repository.languages)
    end
  end

  context 'when filtering by languages', js: true do  
    let!(:repository) { create(:repository, language: 'javascript,ruby,python', company_id: authed_user.company_id).decorate }
    let!(:second_repository) { create(:repository, language: 'Shell,react,python', company_id: authed_user.company_id).decorate }
  
    before do
      visit repositories_path
    end

    it 'have the language javascript' do
      fill_in 'search-input-field', with: 'javascript'
      find('#filter-button').click
      
      expect(page).to have_text(repository.languages)
      expect(page).not_to have_text(second_repository.languages)
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
      
      expect(page).to have_text(repository.languages) &
                      have_text(second_repository.languages)
      expect(page).to have_css('.list-group .list-group-item', :count => 2)
    end
  end
end
