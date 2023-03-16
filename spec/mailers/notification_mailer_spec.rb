require 'spec_helper'

describe NotificationMailer do
  describe 'notification email' do
    context 'when user sign up' do
      let(:user) { FactoryBot.build(:user) }
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

      it 'assigns @name on html_part' do
        expect(mail.html_part.decoded).to match(user.name)
      end

      it 'assigns @name on text_part' do
        expect(mail.text_part.decoded).to match(user.name)
      end

      it 'assigns @email' do
        expect(mail.body.encoded).to match(user.email)
      end

      it 'assigns @password' do
        expect(mail.body.encoded).to match(user.password)
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

      before do
        allow(Devise).to receive(:token_generator).and_return(double(generate: 'xyz'))
      end

      it 'assigns link to edit user password path' do
        expect(mail.body.encoded).to have_link('here', href: edit_user_password_url(reset_password_token: 'xyz'))
      end
    end

    context 'when user change your own password' do
      let(:new_password) { Faker::Lorem.characters(number: 8) }
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
      let(:admin) { build(:user, :admin) }
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
      let(:admins) { build_list :user, 2, :admin }
      let(:extra_hour_punches) do
        from = "2018-07-03 17:00".to_time
        to   = from + 2.hours
        create_list :punch, 1, extra_hour: true, user: user, from: from, to: to
      end
      let(:mail) { NotificationMailer.notify_admin_extra_hour([[user.name, extra_hour_punches]], admins.map(&:email)) }

      it 'renders the subject' do
        expect(mail.subject).to eq 'Punchclock - Horas extra registradas'
      end
    end

    context 'when notify user to fill punch' do
      let(:user) { build(:user) }
      let(:mail) do
        NotificationMailer.notify_user_to_fill_punch(user)
      end

      before { ENV['HOST'] = 'punchclock.cm42.io' }

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
        expect(mail.body).to match('Preencham o punch entre os dias 16 e 15') &
          match('https://punchclock.cm42.io')
      end
    end

    context 'when notify user about unregistered punches' do
      let(:user) { build(:user) }
      let(:unregistered_punches) { { '18/06/2019' => 0 } }
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

    context 'when notify newsletter about approved contributions' do
      let(:user) { build(:user, :admin) }
      let(:contributions) { 'Lista de Contribuições Aprovadas' }
      let(:receiver) { 'news@cm42.io' }
      let(:mail) { NotificationMailer.notify_newsletter_contributions(contributions) }

      before { ENV['NEWS_EMAIL'] = receiver }

      it 'renders the subject' do
        expect(mail.subject).to eq('Punchlock - Contribuições aprovadas')
      end

      it 'renders the receiver email' do
        expect(mail.to).to contain_exactly(receiver)
      end

      it 'renders the sender email' do
        expect(mail.from).to contain_exactly('do-not-reply@punchclock.com')
      end

      it 'renders the body' do
        expect(mail.body).to match(contributions)
      end
    end

    context 'when a registration email is sent again through admin' do
      let(:user) { create(:user, name: "Art Vandelay") }
      let(:mail) { NotificationMailer.resend_user_registration(user, 'xyz') }

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

      it 'assigns link to edit user password path' do
        expect(mail.body.encoded).to have_link('here', href: edit_user_password_url(reset_password_token: 'xyz'))
      end
    end
  end
end
