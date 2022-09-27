# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Repositories::Sync, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#call' do
    subject(:call) { described_class.new(client: client).call }

    let(:client) { instance_double('Github') }

    context 'when there are no repositories in database' do

      it { is_expected.to be_empty }
    end

    # TODO: Add specs to cover all use cases
  end
end
