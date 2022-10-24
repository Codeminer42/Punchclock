# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::Update, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#call' do
    subject { described_class.new(client: client) }

    let(:client) { class_double('Github') }

    context 'when PR state changed' do
      before do
        allow(client).to receive(:issues).and_return(pull_request_status)
      end

      let!(:contribution) { create(:contribution, :open_pr) }
      let(:pull_request_status) { double(get: get) }
      let(:get) { double(body: response_body) }
      let(:response_body) do
        double(
          state: 'closed',
          pull_request: double({ merged_at: nil })
        )
      end

      it 'updates contribution' do
        expect { subject.call }.to change { contribution.reload.pr_state }.from('open').to('closed')
      end
    end

    context 'when PR state did not changed' do
      before do
        allow(client).to receive(:issues).and_return(pull_request_status)
      end

      let!(:contribution) { create(:contribution, :open_pr) }
      let(:pull_request_status) { double(get: get) }
      let(:get) { double(body: response_body) }
      let(:response_body) do
        double(
          state: 'open',
          pull_request: double({ merged_at: nil })
        )
      end

      it 'do not update contribution' do
        expect(subject).not_to receive(:update)
        subject.call
      end
    end
  end
end
