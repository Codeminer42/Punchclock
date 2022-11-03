# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'do-not-reply@punchclock.com'
  layout 'mailer'
end
