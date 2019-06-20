require 'spec_helper'

describe NotificationMailer do
  describe 'notification email' do
    context 'when user sign up' do
      let(:user) { FactoryBot.build(:user_admin) }
      let(:mail) { NotificationMailer.notify_user_registration(user) }

      it 'renders the subject' do
        expect(mail.subject).to eq('Welcome to Punchclock')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns @name' do
        expect(mail.body.encoded).to match(user.name)
      end

      it 'assigns @email' do
        expect(mail.body.encoded).to match(user.email)
      end

      it 'assigns @password' do
        expect(mail.body.encoded).to match(user.password)
      end
    end

    context 'when admin user has been registered' do
      let(:admin_user) { FactoryBot.create(:admin_user) }
      let(:mail) { NotificationMailer.notify_admin_registration(admin_user) }

      it 'renders the subject' do
        expect(mail.subject).to eq('You were registered on Punchclock')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([admin_user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'should have a company' do
        expect(mail.body.encoded).to match(admin_user.company.name)
      end

      it 'assigns @email' do
        expect(mail.body.encoded).to match(admin_user.email)
      end

      it 'assigns @password' do
        expect(mail.body.encoded).to match(admin_user.password)
      end

      it 'assigns link to edit password path' do
        expect(mail.body.encoded).to have_link(
          'here', href: edit_admin_admin_user_url(admin_user)
        )
      end
    end

    context 'when user has been registered' do
      let(:user) do
        User.new(
          name: 'username',
          email: 'username@domain.sf',
          password: '12345678',
          password_confirmation: '12345678'
        )
      end
      let(:mail) { NotificationMailer.notify_user_registration(user) }

      it 'renders the subject' do
        expect(mail.subject).to eq('Welcome to Punchclock')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns @name' do
        expect(mail.body.encoded).to match(user.name)
      end

      it 'assigns @email' do
        expect(mail.body.encoded).to match(user.email)
      end

      it 'assigns @password' do
        expect(mail.body.encoded).to match(user.password)
      end

      it 'assigns link to edit password path' do
        expect(mail.body.encoded).to have_link(
          'here', href: users_account_password_edit_url
        )
      end
    end

    context 'when user change your own password' do
      let(:new_password) { Faker::Lorem.characters(8) }
      let(:user) { create(:user) }
      let(:mail) do
        NotificationMailer.notify_user_password_change(user, new_password)
      end

      it 'renders the subject' do
        expect(mail.subject).to eq('Punchclock - Your password has been modified')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns @name' do
        expect(mail.body.encoded).to match(user.name)
      end

      it 'assigns @email' do
        expect(mail.body.encoded).to match(user.email)
      end

      it 'assigns @password' do
        expect(mail.body.encoded).to match(new_password)
      end
    end

    context 'when notify admin: user dont punch makes 7 days or more' do
      let(:user) { build(:user) }
      let(:admin) { build(:admin_user, company_id: user.company_id) }
      let(:mail) do
        NotificationMailer.notify_admin_punches_pending(admin, user)
      end

      it 'renders the subject' do
        expect(mail.subject).to eq("Punchclock - #{user.name} still inactive")
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([admin.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns user @name' do
        expect(mail.body.encoded).to match(user.name)
      end
    end

    context 'when notify admin: extra hour' do
      let(:user) { build :user }
      let(:admins) { build_list :admin_user, 2, company_id: user.company_id }
      let(:extra_hour_punches) do
        from = "2018-07-03 17:00".to_time
        to   = from + 2.hours
        create_list :punch, 1, extra_hour: true, user: user, from: from, to: to
      end
      let(:mail) { NotificationMailer.notify_admin_extra_hour([[user.name, extra_hour_punches]], admins) }

      it 'renders the subject' do
        expect(mail.subject).to eq 'Punchclock - Horas extra registradas'
      end
    end

    context 'when notify user to fill punch' do
      let(:user) { build(:user) }
      let(:mail) do
        NotificationMailer.notify_user_to_fill_punch(user)
      end

      it 'renders the subject' do
        expect(mail.subject).to eq("Preencher Punch")
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([user.email])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'renders the body' do
        expect(mail.body).to match('Preencham o punch entre os dias 16 e 15')
      end
    end

    context 'when notify user about unregistered punches' do
      let(:user) { build(:user) }
      let(:unregistered_punches) { {Date.new(2019, 06, 18) => 0} }
      let(:mail) do
        NotificationMailer.notify_unregistered_punches(user, unregistered_punches)
      end

      it 'renders the subject' do
        expect(mail.subject).to eq("Punchclock - #{user.name} com Punches não cadastrados no sistema")
      end

      it 'renders the receiver email' do
        expect(mail.to).to contain_exactly(user.email)
      end

      it 'renders the sender email' do
        expect(mail.from).to contain_exactly('do-not-reply@punchclock.com')
      end

      it 'renders the body' do
        expect(mail.body).to match('18/06/2019')
      end
    end
  end
end
