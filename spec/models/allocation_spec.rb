# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Allocation, type: :model do
  describe 'Associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:project) }
  end

  describe 'Delegate' do
    it { is_expected.to delegate_method(:office_name).to(:user) }
  end

  describe 'validate' do
    let(:user) { create(:user) }
    let(:user_2) { create(:user) }

    context 'end_at' do
      it 'should not be before start_at' do
        allocation = build(:allocation, user: user, start_at: 4.days.after, end_at: 2.days.after)
        allocation.validate
        expect(allocation.errors[:end_at]).to eq(['A data de término deve ser maior que a data de início'])
      end
    end

    context 'selected dates' do
      before do
        create(:allocation, user: user, end_at: 1.week.after)
      end

      it 'overlaps an existing period to same user' do
        allocation = build(:allocation, user: user, start_at: 2.days.after, end_at: 2.week.after)
        allocation.validate
        expect(allocation.errors[:start_at]).to eq(['Já existe uma alocação desse usuário nesse período'])
      end

      it 'do not overlaps an existing period to another user' do
        allocation = build(:allocation, user: user_2, start_at: 2.days.after, end_at: 2.week.after)
        allocation.validate
        expect(allocation.errors[:start_at]).not_to eq(['Já existe uma alocação desse usuário nesse período'])
      end

      it 'do not overlaps an existing period' do
        allocation = build(:allocation, user: user, start_at: 8.days.after, end_at: 2.week.after)
        allocation.validate
        expect(allocation.errors[:start_at]).not_to eq(['Já existe uma alocação desse usuário nesse período'])
      end
    end

    context 'endless allocation' do
      context 'nowdays' do
        before do
          create(:allocation, user: user, start_at: 4.days.ago, end_at: nil)
        end

        it 'when user has' do
          allocation = build(:allocation, :with_end_at, user: user)
          allocation.validate
          expect(allocation.errors[:start_at]).to eq(['Já existe uma alocação desse usuário nesse período'])
        end

        it 'when user has not' do
          allocation = build(:allocation, :with_end_at, user: user_2)
          allocation.validate
          expect(allocation.errors[:start_at]).not_to eq(['Já existe uma alocação desse usuário nesse período'])
        end

        it 'on update should not validate itself' do
          allocation = Allocation.last
          allocation.end_at = Date.tomorrow
          allocation.validate
          expect(allocation.errors[:start_at]).not_to eq(['Já existe uma alocação desse usuário nesse período'])
        end
      end

      context 'in future' do
        before do
          create(:allocation, user: user, start_at: 1.month.after, end_at: nil)
        end

        context 'create' do
          it 'should not be possible create other endless allocation at all' do
            allocation = build(:allocation, user: user)
            allocation.validate
            expect(allocation.errors[:start_at]).to eq(['Já existe uma alocação desse usuário nesse período'])
          end

          it 'should be possible create an allocation with end_at before the endless allocation' do
            allocation = build(:allocation, :with_end_at, user: user)
            allocation.validate
            expect(allocation.errors[:start_at]).not_to eq(['Já existe uma alocação desse usuário nesse período'])
          end
        end

        context 'update' do
          let(:allocation) { create(:allocation, end_at: 2.week.after, user: user) }

          it 'should not be possible update an allocation to be endless' do
            allocation.end_at = nil
            allocation.validate
            expect(allocation.errors[:start_at]).to eq(['Já existe uma alocação desse usuário nesse período'])
          end

          it 'should be possible update an allocation with end_at before the endless allocation' do
            allocation.end_at = 1.week.after
            allocation.validate
            expect(allocation.errors[:start_at]).not_to eq(['Já existe uma alocação desse usuário nesse período'])
          end
        end
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
    let!(:allocation1) do
      create(:allocation,
             start_at: 2.week.ago,
             end_at: 1.week.after,
             user: user1)
    end
    let!(:allocation2) do
      create(:allocation,
             start_at: 2.week.ago,
             end_at: 1.week.after,
             user: user2)
    end
    let!(:allocation3) do
      create(:allocation,
             start_at: 2.month.ago,
             end_at: 1.month.ago,
             user: user1)
    end
    let!(:allocation4) do
      create(:allocation,
             start_at: 2.month.ago,
             end_at: 1.month.ago,
             user: user2)
    end

    let(:ongoing_allocations) { described_class.ongoing.map { |allocation| allocation } }
    let(:finished_allocations) { described_class.finished.map { |allocation| allocation } }

    it 'is ongoing' do
      expect(ongoing_allocations).to eq([allocation2])
    end

    it 'is finished' do
      expect(finished_allocations).to eq([allocation4])
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
      subject { build_stubbed(:allocation, end_at: Date.current.next_month) }

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
  end
end
