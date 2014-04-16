require 'spec_helper'

describe NotificationMailer do
  describe 'notification email' do
    context 'when user sign up' do
      let(:user) { FactoryGirl.build(:user_admin) }
      let(:mail) { NotificationMailer.notify_user_registration(user) }

      it 'renders the subject' do
        mail.subject.should == 'Welcome to Punchclock'
      end

      it 'renders the receiver email' do
        mail.to.should == [user.email]
      end

      it 'renders the sender email' do
        mail.from.should == ['do-not-reply@punchclock.com']
      end

      it 'assigns @name' do
        mail.body.encoded.should match(user.name)
      end

      it 'assigns @email' do
        mail.body.encoded.should match(user.email)
      end

      it 'assigns @password' do
        mail.body.encoded.should match(user.password)
      end
    end

    context 'when admin user has been registered' do
      let(:admin_user) { FactoryGirl.create(:admin_user) }
      let(:mail) { NotificationMailer.notify_admin_registration(admin_user) }

      it 'renders the subject' do
        mail.subject.should == 'You was registered on Punchclock'
      end

      it 'renders the receiver email' do
        mail.to.should == [admin_user.email]
      end

      it 'renders the sender email' do
        mail.from.should == ['do-not-reply@punchclock.com']
      end

      it 'should have a company' do
        mail.body.encoded.should match(admin_user.company.name)
      end

      it 'assigns @email' do
        mail.body.encoded.should match(admin_user.email)
      end

      it 'assigns @password' do
        mail.body.encoded.should match(admin_user.password)
      end

      it 'assigns link to edit password path' do
        mail.body.encoded.should have_link('here', href: edit_admin_admin_user_url(admin_user))
      end
    end

    context 'when user has been registered' do
    	 let(:user) { User.new(name: 'username', email: 'username@domain.sf', password: '12345678', password_confirmation: '12345678') }
    	 let(:mail) { NotificationMailer.notify_user_registration(user) }

    	 it 'renders the subject' do
     		 mail.subject.should == 'Welcome to Punchclock'
     	end

      it 'renders the receiver email' do
        mail.to.should == [user.email]
      end

      it 'renders the sender email' do
        mail.from.should == ['do-not-reply@punchclock.com']
      end

      it 'assigns @name' do
        mail.body.encoded.should match(user.name)
      end

      it 'assigns @email' do
        mail.body.encoded.should match(user.email)
      end

      it 'assigns @password' do
        mail.body.encoded.should match(user.password)
      end

      it 'assigns link to edit password path' do
        mail.body.encoded.should have_link('here', href: users_account_password_edit_url)
      end
    end

    context 'when user change your own password' do
      let(:new_password) { Faker::Lorem.characters(8) }
      let(:user) { FactoryGirl.create(:user) }
      let(:mail) { NotificationMailer.notify_user_password_change(user, new_password) }

      it 'renders the subject' do
        mail.subject.should == 'Punchclock - Your password has been modified'
      end

      it 'renders the receiver email' do
        mail.to.should == [user.email]
      end

      it 'renders the sender email' do
        mail.from.should == ['do-not-reply@punchclock.com']
      end

      it 'assigns @name' do
        mail.body.encoded.should match(user.name)
      end

      it 'assigns @email' do
        mail.body.encoded.should match(user.email)
      end

      it 'assigns @password' do
        mail.body.encoded.should match(new_password)
      end
    end

    context 'when notify admin: user dont punch makes 7 days or more' do
      let(:user) { FactoryGirl.build(:user) }
      let(:admin) { FactoryGirl.build(:user_admin, company_id: user.company_id) }
      let(:mail) { NotificationMailer.notify_admin_punches_pending(admin, user) }

      it 'renders the subject' do
        mail.subject.should == "Punchclock - #{user.name} still inactive"
      end

      it 'renders the receiver email' do
        mail.to.should == [admin.email]
      end

      it 'renders the sender email' do
        mail.from.should == ['do-not-reply@punchclock.com']
      end

      it 'assigns user @name' do
        mail.body.encoded.should match(user.name)
      end

      it 'assigns admin @name' do
        mail.body.encoded.should match(admin.name)
      end
    end
  end
end
