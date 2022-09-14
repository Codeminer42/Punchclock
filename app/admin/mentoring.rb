# frozen_string_literal: true

ActiveAdmin.register_page 'Mentoring' do
  menu label: proc { I18n.t('mentoring') }, parent: User.model_name.human(count: 2)

  content title: I18n.t('mentoring') do
    tabs do
      mentoring = MentoringQuery.new
      tab I18n.t('mentoring') do
        mentors = mentoring.call
        table_for mentors do
          column(I18n.t('mentor')) { |mentor| mentor.mentors }
          column(:office) { |office| office.city }
          column(I18n.t('mentees')) { |mentee| mentee.mentees }
        end
      end
    end
  end
end
