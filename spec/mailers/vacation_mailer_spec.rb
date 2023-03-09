require 'spec_helper'

describe VacationMailer do
  describe 'vacation email' do
    context 'when user requests a vacation' do
      let(:admins) { build_list :user, 2, :admin }
      let(:vacation) { FactoryBot.create(:vacation) }
      let(:mail) { VacationMailer.notify_vacation_request(vacation, admins.map(&:email)) }
      let(:hr_mail) { 'hr@email.com' }

      it 'renders the subject' do
        expect(mail.subject).to eq(t 'vacation_mailer.notify_vacation_request.subject', user: vacation.user.name)
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq(admins.map(&:email))
      end

      it 'renders the CC email' do
        stub_const 'ENV', 'HR_EMAIL' => hr_mail

        expect(mail.cc).to eq([hr_mail])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns @name on html_part' do
        expect(mail.html_part.decoded).to match(vacation.user.name)
      end

      it 'assigns @name on text_part' do
        expect(mail.text_part.decoded).to match(vacation.user.name)
      end

      it 'assigns @start_date on html_part' do
        expect(mail.html_part.decoded).to match(l vacation.start_date)
      end

      it 'assigns @start_date on text_part' do
        expect(mail.text_part.decoded).to match(l vacation.start_date)
      end

      it 'assigns @end_date on html_part' do
        expect(mail.html_part.decoded).to match(l vacation.end_date)
      end

      it 'assigns @end_date on text_part' do
        expect(mail.text_part.decoded).to match(l vacation.end_date)
      end

      it 'renders the approve button' do
        expect(mail.html_part.decoded).to match(t 'vacation_mailer.notify_vacation_request.approve_button')
      end

      it 'renders the deny button' do
        expect(mail.html_part.decoded).to match(t 'vacation_mailer.notify_vacation_request.deny_button')
      end
    end

    context 'when a vacation gets approved' do
      let(:admins) { build_list :user, 2, :admin }
      let(:vacation) { FactoryBot.build(:vacation) }
      let(:mail) { VacationMailer.notify_vacation_approved(vacation) }
      let(:count) { "#{vacation.duration_days} dias" }
      let(:hr_mail) { 'hr@email.com' }

      it 'renders the subject' do
        expect(mail.subject).to eq(t 'vacation_mailer.notify_vacation_approved.subject')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([vacation.user.email])
      end

      it 'renders the CC email' do
        stub_const 'ENV', 'HR_EMAIL' => hr_mail

        expect(mail.cc).to eq([hr_mail])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns @count on html_part' do
        expect(mail.html_part.decoded).to match(count)
      end

      it 'assigns @count on text_part' do
        expect(mail.text_part.decoded).to match(count)
      end

      it 'assigns @start_date on html_part' do
        expect(mail.html_part.decoded).to match(l vacation.start_date)
      end

      it 'assigns @start_date on text_part' do
        expect(mail.text_part.decoded).to match(l vacation.start_date)
      end

      it 'assigns @end_date on html_part' do
        expect(mail.html_part.decoded).to match(l vacation.end_date)
      end

      it 'assigns @end_date on text_part' do
        expect(mail.text_part.decoded).to match(l vacation.end_date)
      end
    end

    context 'when a vacation gets refused' do
      let(:admins) { build_list :user, 2, :admin }
      let(:vacation) { FactoryBot.build(:vacation) }
      let(:mail) { VacationMailer.notify_vacation_denied(vacation) }
      let(:hr_mail) { 'hr@email.com' }

      it 'renders the subject' do
        expect(mail.subject).to eq(t 'vacation_mailer.notify_vacation_denied.subject')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq([vacation.user.email])
      end

      it 'renders the CC email' do
        stub_const 'ENV', 'HR_EMAIL' => hr_mail

        expect(mail.cc).to eq([hr_mail])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns @start_date on html_part' do
        expect(mail.html_part.decoded).to match(l vacation.start_date)
      end

      it 'assigns @start_date on text_part' do
        expect(mail.text_part.decoded).to match(l vacation.start_date)
      end

      it 'assigns @end_date on html_part' do
        expect(mail.html_part.decoded).to match(l vacation.end_date)
      end

      it 'assigns @end_date on text_part' do
        expect(mail.text_part.decoded).to match(l vacation.end_date)
      end
    end

    context 'when a vacation is cancelled by the user' do
      let!(:vacation_managers) { create_list :user, 2, :commercial }
      let(:vacation) { FactoryBot.build(:vacation) }
      let(:mail) { VacationMailer.notify_vacation_cancelled(vacation) }
      let(:count) { "#{vacation.duration_days} dias" }
      let(:hr_mail) { 'hr@email.com' }

      it 'renders the subject' do
        expect(mail.subject).to eq(t 'vacation_mailer.notify_vacation_cancelled.subject', user: vacation.user.name)
      end

      it 'renders the receivers emails' do
        expect(mail.to).to eq(vacation_managers.map(&:email))
      end

      it 'renders the CC email' do
        stub_const 'ENV', 'HR_EMAIL' => hr_mail

        expect(mail.cc).to eq([hr_mail])
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns @name on html_part' do
        expect(mail.html_part.decoded).to match(vacation.user.name)
      end

      it 'assings @name on text_part' do
        expect(mail.text_part.decoded).to match(vacation.user.name)
      end

      it 'assigns @count on html_part' do
        expect(mail.html_part.decoded).to match(count)
      end

      it 'assigns @count on text_part' do
        expect(mail.text_part.decoded).to match(count)
      end

      it 'assigns @start_date on html_part' do
        expect(mail.html_part.decoded).to match(l vacation.start_date)
      end

      it 'assigns @start_date on text_part' do
        expect(mail.text_part.decoded).to match(l vacation.start_date)
      end

      it 'assigns @end_date on html_part' do
        expect(mail.html_part.decoded).to match(l vacation.end_date)
      end

      it 'assigns @end_date on text_part' do
        expect(mail.text_part.decoded).to match(l vacation.end_date)
      end
    end

    context 'when an email was sended remembering the hr/commercial users of the pending vacations' do
      let!(:vacation_managers) { FactoryBot.create_list :user, 2, :commercial }
      let(:vacations) { FactoryBot.create_list(:vacation, 1, :pending) }
      let(:mail) { VacationMailer.notify_pending_vacations(vacation_managers, vacations) }

      it 'renders the subject' do
        expect(mail.subject).to eq(t 'vacation_mailer.notify_pending_vacations.subject')
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq(vacation_managers.map(&:email))
      end

      it 'renders the sender email' do
        expect(mail.from).to eq(['do-not-reply@punchclock.com'])
      end

      it 'assigns @name on html_part' do
        expect(mail.decode_body).to match(vacations.first.user.name)
      end

      it 'assigns @start_date on html_part' do
        expect(mail.decode_body).to match(l vacations.first.start_date)
      end

      it 'assigns @end_date on html_part' do
        expect(mail.decode_body).to match(l vacations.first.end_date)
      end

      it 'renders the approve button' do
        expect(mail.decode_body).to match(t 'vacation_mailer.notify_pending_vacations.approve_button')
      end

      it 'renders the deny button' do
        expect(mail.decode_body).to match(t 'vacation_mailer.notify_pending_vacations.deny_button')
      end
    end
  end
end
