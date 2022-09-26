# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Github::Contributions::Create, type: :service do
  include EnvHelper

  around do |example|
    with_temp_env('GITHUB_OAUTH_TOKEN' => 'github-api-token', &example)
  end

  describe '#call' do
    subject(:call) { described_class.new(client: client).call }

    let(:client) { instance_double('Github') }

    # TODO: Add specs to cover all use cases
  end
end
