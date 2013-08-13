require 'spec_helper'

describe HomeController do

  describe "GET index" do

    context "unauthenticated user" do
      it "renders index" do
        get :index
        expect(response).to render_template(:index)
      end
    end # context

    context "authenticated user" do
      login_user

      it "redirects to punches" do
        get :index
        expect(response).to redirect_to(punches_url)
      end
    end # context

  end

end
