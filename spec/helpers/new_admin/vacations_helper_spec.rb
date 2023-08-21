# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::VacationsHelper, type: :helper do
  describe '#scoped_active_class' do
    context 'when no scope is selected' do
      let(:scope) { NewAdmin::VacationsQuery::DEFAULT_SCOPE }

      it 'returns default active button color' do
        expect(helper.scoped_active_class(scope)).to eq(described_class::ACTIVE_BUTTON_COLOR)
      end
    end

    context 'when scope is selected' do
      before { allow(helper).to receive(:params).and_return({ scope: }) }

      let!(:scope) { helper.vacation_query_scopes.sample }

      it 'returns active color for selected scope, and inactive for others', :aggregate_failures do
        expect(helper.scoped_active_class(scope)).to eq(described_class::ACTIVE_BUTTON_COLOR)

        unselected_scopes = helper.vacation_query_scopes - [scope]

        unselected_scopes.each do |unselected_scope|
          expect(helper.scoped_active_class(unselected_scope)).to eq(described_class::INACTIVE_BUTTON_COLOR)
        end
      end
    end
  end

  describe '#vacation_scope_selector' do
    before { allow(helper).to receive(:params).and_return({ scope: }) }

    let!(:pending_vacations) { create_list(:vacation, 2, :pending) }
    let(:scope) { 'pending' }

    it 'returns string containing title and count of vacation scope', :aggregate_failures do
      expect(helper.vacation_scope_selector(scope)).to include(I18n.t('vacations.scopes.pending'))
      expect(helper.vacation_scope_selector(scope)).to include(pending_vacations.count.to_s)
    end
  end
end
