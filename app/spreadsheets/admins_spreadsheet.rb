# frozen_string_literal: true

class AdminsSpreadsheet
  def initialize(admin_users)
    @admin_users = admin_users
    @book = Spreadsheet::Workbook.new
    @sheet = @book.create_worksheet name: 'admin_users'
  end

  def generate_xls
    set_header
    create_body

    data_to_send = StringIO.new
    @book.write data_to_send
    data_to_send.string
  end

  private

  def create_body
    @admin_users.each.with_index do |user, index|
      @sheet.row(index + 1).concat [user.id,
                                    user.email,
                                    I18n.t(user.current_sign_in_at),
                                    I18n.t(user.last_sign_in_at),
                                    I18n.t(user.current_sign_in_ip),
                                    I18n.t( user.last_sign_in_ip),
                                    I18n.t(user.created_at),
                                    I18n.t(user.updated_at),
                                    user.name,
                                    user.reset_password_token,
                                    user.reset_password_sent_at,
                                    user.remember_created_at,
                                    user.hour_cost,
                                    user.confirmation_token,
                                    I18n.t(user.confirmed_at),
                                    I18n.t(user.confirmation_sent_at),
                                    user.active,
                                    user.allow_overtime,
                                    user.occupation,
                                    user.observation,
                                    user.specialty,
                                    user.github,
                                    user.contract_type,
                                    user.role]

    end
  end

  def set_header
    @sheet.row(0).concat %W[#{User.human_attribute_name('id')}
                            #{User.human_attribute_name('email')}
                            #{User.human_attribute_name('current_sign_in_at')}
                            #{User.human_attribute_name('last_sign_in_at')}
                            #{User.human_attribute_name('current_sign_in_ip')}
                            #{User.human_attribute_name('last_sign_in_ip')}
                            #{User.human_attribute_name('created_at')}
                            #{User.human_attribute_name('updated_at')}
                            #{User.human_attribute_name('name')}
                            #{User.human_attribute_name('reset_password_token')}
                            #{User.human_attribute_name('reset_password_sent_at')}
                            #{User.human_attribute_name('remember_created_at')}
                            #{User.human_attribute_name('hour_cost')}
                            #{User.human_attribute_name('confirmation_token')}
                            #{User.human_attribute_name('confirmed_at')}
                            #{User.human_attribute_name('confirmation_sent_at')}
                            #{User.human_attribute_name('active')}
                            #{User.human_attribute_name('allow_overtime')}
                            #{User.human_attribute_name('occupation')}
                            #{User.human_attribute_name('observation')}
                            #{User.human_attribute_name('specialty')}
                            #{User.human_attribute_name('github')}
                            #{User.human_attribute_name('contract_type')}
                            #{User.human_attribute_name('role')}]

    @sheet.row(0).default_format = Spreadsheet::Format.new weight: :bold
  end
end
