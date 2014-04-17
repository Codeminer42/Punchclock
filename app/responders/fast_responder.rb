class FastResponder < ApplicationResponder
  def to_html
    if put? && !has_errors?
      render action: :index
    else
      super
    end
  end
end
