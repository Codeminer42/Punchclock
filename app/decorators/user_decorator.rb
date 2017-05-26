class UserDecorator < ApplicationDecorator
  delegate_all

  def hour_cost
    "Cost: #{object.hour_cost.to_f} R$/h"
  end
end
