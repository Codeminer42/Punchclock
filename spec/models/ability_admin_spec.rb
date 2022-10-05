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

  describe 'abilities open source manager' do
    let(:open_source_manager_user) { create(:user, :open_source_manager) }
    let(:ability_open_source_manager) { AbilityAdmin.new(open_source_manager_user) }

    it 'able to read dashboard' do
      expect(ability_open_source_manager).to be_able_to :read, ActiveAdmin::Page, name: 'Dashboard'
    end

    it 'able to manage Repository' do
      expect(ability_open_source_manager).to be_able_to :manage, Repository
    end

    it 'able to manage Contribution' do
      expect(ability_open_source_manager).to be_able_to :manage, Contribution
    end

    it 'able to create Repository' do
      expect(ability_open_source_manager).to be_able_to :create, Repository
    end

    it "can't manage User on active admin" do
      expect(ability_open_source_manager).to_not be_able_to :manage, User
    end

    it "can't manage Punch on active admin" do
      expect(ability_open_source_manager).to_not be_able_to :manage, Punch
    end
  end
end
