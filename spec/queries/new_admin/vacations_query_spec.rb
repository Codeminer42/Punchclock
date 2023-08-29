# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAdmin::VacationsQuery do
  describe '#self.call' do
    let!(:ongoing_vacation) { create(:vacation, :ongoing) }
    let!(:pending_vacations) { create_list(:vacation, 2, :pending) }

    context 'when no scope filter is present' do
      it 'returns ongoing and scheduled vacations by default' do
        expect(described_class.call({})).to contain_exactly(ongoing_vacation)
      end
    end

    context 'when scope is filtered' do
      it 'returns filtered vacations by their status' do
        expect(described_class.call({ scope: 'pending' })).to eq(pending_vacations)
      end
    end
  end
end
