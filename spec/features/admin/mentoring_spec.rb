# frozen_string_literal: true

require 'rails_helper'

describe 'Mentoring', type: :feature do
  let(:admin) { create(:user, :admin, occupation: :administrative) }
  let(:mentor) { create(:user) }
  let!(:mentee) { create(:user, mentor_id: mentor.id) }

  before do
    sign_in(admin)
  end

  describe 'page' do
    before { visit 'admin/mentoring' }

    context 'tabs' do
      context 'mentoring tab' do
        it 'have "Mentor", "Escritório", "Mentorados"' do
          within '#mentoria' do
            expect(page).to have_text('Mentor') && have_text('Escritório') && have_text('Mentorados')
          end
        end

        context 'table rows' do
          it 'has mentors name in "Mentor" column' do
            within '#mentoria' do
              expect(page).to have_text(mentor.name)
            end
          end

          it 'has mentors office in "Escritório" column' do
            within '#mentoria' do
              expect(page).to have_text(mentor.office)
            end
          end

          it 'has mentees name in "Mentorados" column' do
            within '#mentoria' do
              expect(page).to have_text(mentee.name)
            end
          end
        end
      end

      context 'offices tab' do
        it 'have "Mentor", "Escritório", "Mentorados"' do
          within '#escritorios' do
            expect(page).to have_text('Escritórios') && have_text('Mentores') && have_text('Mentorados')
          end
        end

        context 'table rows' do
          it 'has mentors office in "Escritórios" column' do
            within '.mentoring_table' do
              expect(page).to have_text(mentor.office)
            end
          end

          it 'has mentors name in "Mentores" column' do
            within '.mentoring_table' do
              expect(page).to have_text(mentor.name)
            end
          end

          it 'has mentees name in "Mentorados" column' do
            within '.mentoring_table' do
              expect(page).to have_text(mentee.name)
            end
          end
        end
      end
    end
  end
end
