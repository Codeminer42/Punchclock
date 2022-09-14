# frozen_string_literal: true

require 'rails_helper'

describe 'Mentoring', type: :feature do
  let(:admin) { create(:user, :admin, occupation: :administrative) }
  let(:mentor) { create(:user) }
  let!(:mentee) { create(:user, reviewer_id: mentor.id) }

  before do
    sign_in(admin)
  end

  describe 'page' do
    before { visit 'admin/mentoring' }

    context 'table fields' do
      it 'have "Mentor", "Escritório", "Mentorados"' do
        within 'table' do
          aggregate_failures 'testing table fields' do
            expect(page).to have_text('Mentor')
            expect(page).to have_text('Escritório')
            expect(page).to have_text('Mentorados')
          end
        end
      end
    end

    context 'table row' do
      it 'has mentors name in "Mentor" column' do
        within 'tbody' do
          expect(page).to have_text(mentor.name)
        end
      end

      it 'has mentors office in "Escritório" column' do
        within 'tbody' do
          expect(page).to have_text(mentor.office)
        end
      end

      it 'has mentees name in "Mentorados" column' do
        within 'tbody' do
          expect(page).to have_text(mentee.name)
        end
      end
    end
  end
end
