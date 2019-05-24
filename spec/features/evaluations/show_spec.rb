# frozen_string_literal: true

require 'rails_helper'

describe "Visit Show", type: :feature do
  let(:user)        { create_logged_in_user }
  let!(:office)     { create(:office, head: user) }
  let!(:evaluation) { create(:evaluation, :with_answers, company: user.company) }

  before do
    visit '/evaluations'
    find_link('View', href: "/evaluations/#{evaluation.id}").click
  end

  it "finds evaluator name" do
    expect(page).to have_content("Evaluated by: #{evaluation.evaluator.name}")
  end

  it "finds evaluated name" do
    expect(page).to have_content("Evaluating: #{evaluation.evaluated.name}")
  end

  it "finds 'Observation' on the page" do
    expect(page).to have_content 'Observation'
  end

  it 'finds text area for observation' do
    expect(page).to have_css('p', text: evaluation.observation)
  end

  it "go to root page" do
    click_link_or_button 'Back'
    expect(current_path).to eql root_path
  end
end
