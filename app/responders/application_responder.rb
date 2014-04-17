class ApplicationResponder < ActionController::Responder
  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  def to_html
    if resource
      if has_errors?
        render :edit
      else
        super
      end
    else
      redirect_to root_url
    end
  end
end
