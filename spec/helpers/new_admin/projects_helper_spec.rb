# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::ProjectsHelper, type: :helper do
  before do
    klass = Class.new(ApplicationController) do
      include NewAdmin::ProjectsHelper
    end

    stub_const('Klass', klass)
  end

  let(:klass) { Klass.new }

  describe '#market_options_for_select' do
    it 'returns market values to be used in selects' do
      expect(
        klass.market_options_for_select
      ).to match_array([%W[#{I18n.t('projects.market.international')} international],
                        %W[#{I18n.t('projects.market.internal')} internal]])
    end
  end

  describe '#not_allocated_users_options_for_select' do
    let(:name) { 'Paul Atreides' }
    let!(:user) { create(:user, name:) }

    it 'returns non allocated users for select' do
      expect(
        klass.not_allocated_users_options_for_select
      ).to eq([[name, user.id]])
    end
  end
end
