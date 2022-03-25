# frozen_string_literal: true

require 'rails_helper'

describe "Visit Evaluations", type: :feature do
  let!(:user)   { create_logged_in_user }
  let!(:office) { create(:office, head: user) }

  before do
    visit('/evaluations')
  end

  it "finds the user's name on the page" do
    expect(page).to have_content user.name
  end

  it "finds a table on the page" do
    expect(page).to have_css 'table'
  end

  it 'finds fields "Name", "Level", Office", "Last Performance Evaluation", "Last Performance Evaluation score", "Last English Evaluation", "Last English Level" and "Evaluate" on table' do
    within 'table' do
      expect(page).to have_text('Name') &
                      have_text('Level') &
                      have_text('Office') &
                      have_text('Last Performance Evaluation') &
                      have_text('Last Performance Evaluation Score') &
                      have_text('Last English Evaluation') &
                      have_text('Last English Level') &
                      have_text('Evaluate')
    end
  end

  context 'by clicking the performance evaluation view button' do
    let!(:evaluation) { create(:evaluation, :with_answers, company: user.company) }

    it 'then the show last performance evaluation url must have the correct evaluation_id' do
      visit('/evaluations')
      find_link('View', href: "/evaluations/#{evaluation.id}").click

      expect(current_path).to eql(evaluation_path(evaluation.id))
    end
  end

  context 'by clicking the english evaluation view button' do
    let!(:evaluation) { create(:evaluation, :english, :with_answers, company: user.company) }

    it 'then the show last english evaluation url must have the correct evaluation_id' do
      visit('/evaluations')
      find_link('View', href: "/evaluations/#{evaluation.id}").click

      expect(current_path).to eql(evaluation_path(evaluation.id))
    end
  end

  context 'by clicking the add evaluation button' do
    let!(:questionnaire) { create(:questionnaire, active: true) }

    it 'then the new evaluation urls must have the correct evaluated_user_id' do
      find('[name=new-evaluation]').click

      within '.modal-body' do
        expect(page).to have_link(nil, href: "/questionnaires/#{questionnaire.id}/evaluations/new?evaluated_user_id=#{user.id}")
      end
    end
  end
end
