# frozen_string_literal: true

class OnlyAdmins < ActiveAdmin::AuthorizationAdapter
  def authorized?(_action, _subject)
    user.admin?
  end
end
