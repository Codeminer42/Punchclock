# frozen_string_literal: true

require 'rails_helper'

module ActiveAdmin
  describe AllocationChartHelper do
    describe '#allocation_satus_for' do
      let(:current_date) { Time.zone.local(2032, 3, 1, 12, 0, 0) }

      around do |example|
        travel_to current_date, &example
      end

      subject { AllocationChartHelper.allocation_status_for(last_allocation: last_allocation) }

      context 'without allocation' do
        let(:last_allocation) { nil }
        it 'returns NOT_ALLOCATED' do
          is_expected.to eq(AllocationChartHelper::Status::NOT_ALLOCATED)
        end
      end

      context 'when last allocation end date is more than 60 days' do
        let(:last_allocation) { create(:allocation, end_at: current_date + 61.days) }

        it 'returns ALLOCATED' do
          is_expected.to eq(AllocationChartHelper::Status::ALLOCATED)
        end
      end

      context 'when last allocation end date is between 31 and 60 days' do
        let(:last_allocation) { create(:allocation, end_at: current_date + 60.days) }

        it 'returns EXP_IN_60_DAYS' do
          is_expected.to eq(AllocationChartHelper::Status::EXP_IN_60_DAYS)
        end
      end

      context 'when last allocation end date is between 1 and 30 days' do
        let(:last_allocation) { create(:allocation, end_at: current_date + 30.days) }
        it 'returns EXP_IN_30_DAYS' do
          is_expected.to eq(AllocationChartHelper::Status::EXP_IN_30_DAYS)
        end
      end

      context 'when last allocation end date has passed' do
        let(:last_allocation) { create(:allocation, end_at: current_date) }
        it 'returns EXPIRED' do
          is_expected.to eq(AllocationChartHelper::Status::EXPIRED)
        end
      end

      context 'when has passed more than 60 days since last allocation end date' do
        let(:last_allocation) { create(:allocation, start_at: current_date - 62.days, end_at: current_date - 61.days) }
        it 'returns EXPIRED' do
          is_expected.to eq(AllocationChartHelper::Status::EXPIRED)
        end
      end
    end
  end
end
