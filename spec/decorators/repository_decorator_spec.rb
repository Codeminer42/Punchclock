require 'rails_helper'

RSpec.describe RepositoryDecorator do
  describe '#languages' do
    let(:repository1) {create(:repository, language: 'Javascript, Docker, Ruby, HTML, CSS').decorate}
    let(:repository2) {create(:repository, language: 'Javascript, Docker').decorate}

    it 'should return the first 3 languages of the repository' do
      expect(repository1.languages).to eq('Javascript,  Docker e  Ruby')
      expect(repository2.languages).to eq('Javascript e  Docker')
    end
  end
end
