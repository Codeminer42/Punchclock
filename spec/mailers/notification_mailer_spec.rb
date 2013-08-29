require "spec_helper"

describe NotificationMailer do
  describe "notification email" do
  	let(:user) { User.new(name:"username", email:"username@domain.sf") }
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
  end
end