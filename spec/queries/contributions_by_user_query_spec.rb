# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContributionsByUserQuery do
  let(:company) { create(:company) }
  let(:offices) { create_list(:office, 3, { company: company }) }
  let(:user)    { create(:user, company: company, office: offices.first) }

  context '#to_hash' do
    before do
      create_list(:contribution, 6, { user: user, company: company })
    end

    subject(:to_hash) { described_class.new.to_hash }

    it 'return the user name' do
      expect(subject.keys.first).to eq(user.id)
    end

    it 'return the right number of contributions' do
      expect(subject[user.id]).to eq(6)
    end
  end

  context '#by_company' do
    before do
      company_two = create(:company)
      other_office = create(:office, { company: company_two })
      @other_company_user = create(:user, company: company_two, office: other_office)

      create_list(:contribution, 3, { user: user, company: company })
      create_list(:contribution, 5, { user: @other_company_user, company: company_two })
    end

    subject(:by_company) { described_class.new.by_company(company) }

    it 'return contributions of users by company' do
      expect(subject.to_hash.keys).to include(user.id)
    end

    it 'does not return contributions of other_company' do
      expect(subject.to_hash.keys).not_to include(@other_company_user.id)
    end
  end

  context '#per_month' do
    let(:today) { Date.today }
    let(:last_month) { today.month - 1 }

    before do
      create_list(:contribution, 3, { user: user, company: company })
      create_list(:contribution, 3,
                  { user: user, company: company, created_at: Date.new(today.year, last_month, 13) })
    end
    subject(:per_month) { described_class.new.per_month(today.month) }

    it 'returns the number of contributions from the respective month' do
      expect(subject.to_hash.first.last).to eq(3)
    end
  end

  context '#approved' do
    before do
      create_list(:contribution, 3, { user: user, company: company })
      create_list(:contribution, 3, { user: user, company: company, state: :approved })
    end

    subject(:approved) { described_class.new.approved }

    it 'returns the right number of approved contributions' do
      expect(subject.to_hash.first.last).to eq(3)
    end
  end
end
