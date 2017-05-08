require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe AlertFillPunchJob, type: :job do
 describe '.perform_async' do

    subject(:job) { described_class.perform_async }

    it 'is in mailer queue' do
      expect(AlertFillPunchJob.new.queue_name).to eq('mailer')
    end

  end

end
