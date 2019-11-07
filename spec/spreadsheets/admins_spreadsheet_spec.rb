# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminsSpreadsheet do
  let(:user) { create(:user).decorate }
  let(:admins_spreadsheet) { AdminsSpreadsheet.new([user]) }
  let(:header_attributes) do
    %w[
      id
      email
      current_sign_in_at
      last_sign_in_at
      current_sign_in_ip
      last_sign_in_ip
      created_at
      updated_at
      name
      reset_password_token
      reset_password_sent_at
      reset_password_sent_at
      remember_created_at
      hour_cost
      confirmation_token
      confirmed_at
      confirmation_sent_at
      active
      allow_overtime
      occupation
      observation
      specialty
      github
      contract_type
      role
    ].map { |attribute| User.human_attribute_name(attribute) }
  end

  let (:body_attributes) do
    [
      user.id,
      user.email,
      user.current_sign_in_at,
      user.last_sign_in_at,
      user.current_sign_in_ip,
      user.last_sign_in_ip,
      user.created_at,
      user.updated_at,
      user.name,
      user.reset_password_token,
      user.reset_password_sent_at,
      user.remember_created_at,
      user.hour_cost,
      user.confirmation_token,
      user.confirmed_at,
      user.confirmation_sent_at,
      user.active,
      user.allow_overtime,
      user.occupation,
      user.observation,
      user.specialty,
      user.github,
      user.contract_type,
      user.role
    ]
  end

  describe '#to_string_io' do
    subject do
      admins_spreadsheet
        .to_string_io
        .force_encoding('iso-8859-1')
        .encode('utf-8')
    end

    it 'returns spreadsheet data' do
      is_expected.to include(user.email,
                             user.name,
                             user.occupation,
                             user.specialty,
                             user.github,
                             user.contract_type,
                             user.role)
    end

    it 'returns spreadsheet with header' do
      is_expected.to include(User.human_attribute_name('email'),
                             User.human_attribute_name('name'),
                             User.human_attribute_name('specialty'),
                             User.human_attribute_name('github'),
                             User.human_attribute_name('contract_type'),
                             User.human_attribute_name('role'))
    end
  end

  describe '#generate_xls' do
    subject(:spreadsheet) { admins_spreadsheet.generate_xls }

    it 'returns spreadsheet object with header' do
      expect(spreadsheet.row(0)).to containing_exactly(*header_attributes)
    end

    it 'returns spreadsheet object with body' do
      expect(spreadsheet.row(1)).to containing_exactly(*body_attributes)
    end
  end

  describe '#body' do
    subject { admins_spreadsheet.body(user) }

    it 'return body data' do
      is_expected.to containing_exactly(*body_attributes)
    end
  end

  describe '#header' do
    subject { admins_spreadsheet.header }

    it 'returns header data' do
      is_expected.to containing_exactly(*header_attributes)
    end
  end
end
