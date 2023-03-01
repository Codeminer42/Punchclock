# frozen_string_literal: true

ActiveAdmin.register_page 'Mentoring' do
  menu label: proc { I18n.t('mentoring') }, parent: User.model_name.human(count: 2)

  content title: I18n.t('mentoring') do
    tabs do
      mentoring = MentoringQuery.new.call
      tab I18n.t('mentoring') do
        table_for mentoring do
          column(I18n.t('mentor'), &:name)
          column(:office, &:office_city)
          column(I18n.t('mentees'), &:mentee_list)
        end
      end

      tab I18n.t('offices') do
        render 'offices_mentoring', mentorings: mentoring.group_by(&:office_city)
      end
    end
  end
end
