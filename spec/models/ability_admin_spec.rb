# frozen_string_literal: true

require 'spec_helper'
require 'cancan/matchers'

describe 'User' do
  let(:admin_user) { create(:user, :admin) }

  describe 'abilities admin' do
    let(:ability_admin) { AbilityAdmin.new(admin_user) }

    it "can manage it's own punches" do
      expect(ability_admin).to be_able_to :manage, Punch.new(user: admin_user)
    end

    it "can't delete Projects" do
      expect(ability_admin).to_not be_able_to :destroy, Project.new
    end

    it "can edit punch" do
      expect(ability_admin).to be_able_to :edit, Punch.new
    end

    it "can delete punch" do
      expect(ability_admin).to be_able_to :destroy, Punch.new
    end
  end
end
