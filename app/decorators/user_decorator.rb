class UserDecorator < ApplicationDecorator
  delegate_all

  def hour_cost
    "Cost: #{object.hour_cost.to_f} R$/h"
  end

  def admin_role?
    I18n.t(object.is_admin?.to_s)
  end
end
