# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allocation, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  it 'has monetized hourly rate' do
    is_expected.to monetize(:hourly_rate)
  end

  describe 'Delegate' do
    it { is_expected.to delegate_method(:office_name).to(:user) }
  end

  describe 'validate' do
    let(:user) { create(:user) }
    let(:user_2) { create(:user) } 

    it { should validate_presence_of(:start_at) }
    it { should validate_presence_of(:end_at) }
    it { should validate_presence_of(:hourly_rate_currency) }

    context 'end_at' do
      it 'should not be before start_at' do
        allocation = build(:allocation, user: user, start_at: 4.days.after, end_at: 2.days.after )
        allocation.validate
        expect(allocation.errors[:end_at]).to eq(['A data de término deve ser maior que a data de início'])
      end
    end

    context 'selected dates' do  
      before do
        create(:allocation, user: user, end_at: 1.week.after)
      end

      it 'overlaps an existing period to same user' do
        allocation = build(:allocation, user: user, start_at: 2.days.after, end_at: 2.week.after )
        allocation.validate
        expect(allocation.errors[:start_at]).to eq(['Já existe uma alocação desse usuário nesse período'])
      end

      it 'do not overlaps an existing period to another user' do
        allocation = build(:allocation, user: user_2, start_at: 2.days.after, end_at: 2.week.after )
        allocation.validate
        expect(allocation.errors[:start_at]).not_to eq(['Já existe uma alocação desse usuário nesse período'])
      end

      it 'do not overlaps an existing period' do
        allocation = build(:allocation, user: user, start_at: 8.days.after, end_at: 2.week.after )
        allocation.validate
        expect(allocation.errors[:start_at]).not_to eq(['Já existe uma alocação desse usuário nesse período'])
      end
    end

    context 'ongoing' do
      before do
        create(:allocation, user: user, start_at: 4.days.ago, end_at: 1.days.ago, ongoing: true)
      end
      it 'validates uniqueness of ongoing' do
        allocation = build(:allocation, user: user, ongoing: true)
        allocation.validate
        expect(allocation.errors[:ongoing]).to eq([I18n.t('activerecord.errors.models.allocation.attributes.ongoing.uniqueness')])
      end
    end
  end

  describe 'scopes' do
    let!(:user1) { create(:user, active: false) }
    let!(:user2) { create(:user) }
    let!(:allocation1) { create(:allocation,
                                  start_at: 2.week.ago,
                                  end_at: 1.week.after,
                                  ongoing: true,
                                  user: user1)}
    let!(:allocation2) { create(:allocation,
                                  start_at: 2.week.ago,
                                  end_at: 1.week.after,
                                  ongoing: true,
                                  user: user2)}
    let!(:allocation3) { create(:allocation,
                                  start_at: 2.month.ago,
                                  end_at: 1.month.ago,
                                  user: user2)}

    it 'return ongoing allocations' do
      expect(described_class.ongoing).to eq([allocation2])
    end

    it 'return finished allocations' do
      expect(described_class.finished).to eq([allocation3])
    end
  end

  describe '#days_until_finish' do
    context 'when end_at is nil' do
      subject { build_stubbed(:allocation, end_at: nil) }

      it 'returns nil' do
        expect(subject.days_until_finish).to be_nil
      end
    end

    context 'when end_at is not nil' do
      subject { build_stubbed(:allocation, ongoing: true, end_at: Date.current.next_month) }

      it 'returns how many days left' do
        expect(subject.days_until_finish).to eq(subject.end_at - Date.current)
      end
    end

    context 'when its already finished' do
      subject { build_stubbed(:allocation, end_at: Date.current - 1.month) }

      it 'returns finished' do
        expect(subject.days_until_finish).to eq('Finalizado')
      end
    end

    context 'when allocation did not started' do
      subject { build_stubbed(:allocation, end_at: 1.month.from_now) }

      it 'returns finished' do
        expect(subject.days_until_finish).to eq('Não iniciado')
      end
    end
  end

  describe '.hourly_rate_currencies' do
    let!(:brl_allocations) { create_list(:allocation, 2, hourly_rate_currency: 'BRL') }
    let!(:usd_allocation) { create(:allocation, hourly_rate_currency: 'USD') }

    it 'gets the available currencies from allocations without duplicates in ASC order' do
      expect(described_class.hourly_rate_currencies).to eq ['BRL', 'USD']
    end
  end
end
