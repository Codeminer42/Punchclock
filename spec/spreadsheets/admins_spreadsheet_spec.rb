# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdminsSpreadsheet do
  let(:user) { create(:user, :admin, :with_all_datetime_informations).decorate }
  let(:admins_spreadsheet) { AdminsSpreadsheet.new([user]) }
  let(:header_attributes) do
    %w[
      id
      email
      last_sign_in_at
      last_sign_in_ip
      name
      confirmed_at
      active
      allow_overtime
      occupation
      observation
      specialty
      github
      contract_type
      roles
      started_at
      created_at
      updated_at
    ].map { |attribute| User.human_attribute_name(attribute) }
  end

  let (:body_attributes) do
    [
      user.id,
      user.email,
      I18n.l(user.last_sign_in_at, format: :long),
      user.last_sign_in_ip,
      user.name,
      I18n.l(user.confirmed_at, format: :long),
      user.active,
      user.allow_overtime,
      user.occupation,
      user.observation,
      user.specialty,
      user.github,
      user.contract_type,
      user.roles_text,
      I18n.l(user.started_at, format: :long),
      I18n.l(user.created_at, format: :long),
      I18n.l(user.updated_at, format: :long)
    ]
  end

  describe '#to_string_io' do
    subject do
      admins_spreadsheet.to_string_io
    end

    before do
      File.open('/tmp/spreadsheet_temp.xlsx', 'wb') {|f| f.write(subject) }
    end

    it_behaves_like 'a valid spreadsheet'
    it_behaves_like 'a spreadsheet with header and body'
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
