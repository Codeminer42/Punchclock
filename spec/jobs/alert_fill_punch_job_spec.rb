require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.fake!

RSpec.describe AlertFillPunchJob, type: :job do
 describe '.perform_later' do

    subject(:job) { described_class.perform_later }

    it 'is in default queue' do
      expect(AlertFillPunchJob.new.queue_name).to eq('default')
    end

  end

end
