require 'spec_helper'

describe VacationMailer do
  describe 'vacation email' do
    context 'when user requests a vacation' do
      let(:admins) { build_list :user, 2, :admin }
      let(:vacation) { FactoryBot.build(:vacation) }
      let(:mail) { VacationMailer.notify_vacation_request(vacation, admins.map(&:email)) }

      it 'renders the subject' do
        expect(mail.subject).to eq((t 'vacation_mailer.notify_vacation_request.subject', user: vacation.user.name))
      end

      it 'renders the receiver email' do
        expect(mail.to).to eq(admins.map(&:email))
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
    end
  end
end
