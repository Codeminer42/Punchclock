module ActiveAdmin::UsersHelper
  def grouped_users_by_active_status
    User
      .order(name: :asc)
      .group_by(&:active)
      .map do |active, users|
        status = active ? 'Ativo' : 'Inativo'
        options = users.map { |user| [user.name, user.id] }

        [status, options]
      end
      .to_h
  end

  # Generate the status tags following the pattern used by ActiveAdmin
  # https://activeadmin.info/12-arbre-components.html#status-tag
  def skills_tags(user)
    tags = user.user_skills.map do |user_skill|
      style = user_skill.experience_level.expert? ? 'yes' : 'no'
      content_tag(:span, user_skill.skill.title, class: "status_tag #{style}")
    end

    tags.join(" ")
  end
end
