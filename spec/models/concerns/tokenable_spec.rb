# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tokenable do
  let(:tokenable) { build(:user) }

  describe "token generator" do
    it "generates a 32-bit token" do
      tokenable.generate_token
      expect(tokenable.token.length).to eq(32)
    end
  end

  describe "token destructor" do
    it "destroys the token" do
      tokenable.destroy_token
      expect(tokenable.token).to be(nil)
    end
  end
end
