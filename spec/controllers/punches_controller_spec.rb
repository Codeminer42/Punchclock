require 'spec_helper'

describe PunchesController do
  login_user

  describe "GET index" do
    it "searches" do
      search = double(:search)
      expect(search).to receive(:sorts).and_return('from desc')
      expect(search).to receive(:result).and_return([double('punch')])
      expect(Punch).to receive(:search).with(nil).and_return(search)

      get :index
    end
  end

  describe "POST create" do
    let(:project) { FactoryGirl.create(:project) }
    it "creates" do
      post :create, punch: {
        'from(1i)' => '2013',
        'from(2i)' => '08',
        'from(3i)' => '13',
        'from(4i)' => '08',
        'from(5i)' => '00',
        'to(4i)'   => '17',
        'to(5i)'   => '00',
        'project_id'=> project.id
      }
    end
  end

  describe "PUT update" do
    let(:project) { FactoryGirl.create(:project) }
    let(:punch) { FactoryGirl.create(:punch) }

    it "updates" do
      put :update, {
        id: punch.id,
        punch: {
          'from(1i)'   => '2013',
          'from(2i)'   => '08',
          'from(3i)'   => '13',
          'from(4i)'   => '08',
          'from(5i)'   => '00',
          'to(1i)'     => '2013',
          'to(2i)'     => '08',
          'to(3i)'     => '12',
          'to(4i)'     => '17',
          'to(5i)'     => '00',
          'project_id' => project.id
        }
      }
    end
  end
end
