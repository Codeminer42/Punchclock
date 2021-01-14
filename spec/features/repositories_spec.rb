require 'rails_helper'

feature 'Repositories list' do
  let!(:authed_user) { create_logged_in_user }

  let!(:repository) { create(:repository, company_id: authed_user.company_id).decorate }
  let!(:second_repository) { create(:repository, company_id: authed_user.company_id).decorate }

  before do
    visit repositories_path
  end

  it 'have the right count of repositories' do
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
