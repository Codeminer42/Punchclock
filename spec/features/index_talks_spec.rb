require 'rails_helper'

RSpec.describe 'Talks Index page', type: :feature do
  describe 'GET index' do
    context 'when the user has saved talks' do
      let!(:user) { create(:user) }
      let!(:talks) { create_list(:talk, 2, user:) }

      before do
        sign_in user
        visit '/talks'
      end

      it 'renders Talks table with Event Name, Talk Title and Date attributes' do
        within('.card-body') do
          expect(page).to have_text('Nome do evento') &
                          have_text('Título da palestra') &
                          have_text('Data')
        end
      end

      context 'on Talks table' do
        it 'finds user talks event names' do
          within('.card-body') do
            expect(page).to have_text(talks.first.event_name) &
                            have_text(talks.last.event_name)
          end
        end
        it 'finds user talks titles' do
          within('.card-body') do
            expect(page).to have_text(talks.first.talk_title) &
                            have_text(talks.last.talk_title)
          end
        end
        it 'finds user talks dates' do
          within('.card-body') do
            expect(page).to have_text(talks.first.date) &
                            have_text(talks.last.date)
          end
        end
      end
    end

    context 'when the user has no saved talk' do
      let!(:user) { create(:user) }

      before do
        sign_in user
        visit '/talks'
      end

      it 'renders Talks table with Event Name, Talk Title and Date attributes' do
        within('.card-body') do
          expect(page).to have_text('Nome do evento') &
                          have_text('Título da palestra') &
                          have_text('Data')
        end
      end

      context 'on Talks table' do
        it 'finds message saying that no talks were found' do
          within('.card-body') do
            expect(page).to have_text(I18n.t('talks.no_talks_found'))
          end
        end
      end
    end
  end
end
