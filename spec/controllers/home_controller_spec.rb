require 'spec_helper'

describe HomeController do

  describe 'GET index' do
    it 'renders index' do
      get :index
      expect(response).to render_template(:index)
    end
  end
end
