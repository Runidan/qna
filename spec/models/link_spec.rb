require 'rails_helper'

RSpec.describe Link, type: :model do
  it { is_expected.to belong_to(:linkable) }
  
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:url) }

  let(:question) { create(:question) }
  let(:valid_urls) { ['http://example.com', 'https://example.com'] }
  let(:invalid_urls) { ['example', 'www.example', 'http//example', 'ftp://example.com'] }
  let(:blank) { '' }

  context 'when format' do
    it 'is valid' do
      valid_urls.each do |valid_url|
        expect(question.links.new(name: "Url name", url: valid_url)).to be_valid
      end
    end

    it 'is not valid' do
      invalid_urls.each do |invalid_url|
        expect(question.links.new(name: "Url name", url: invalid_url)).not_to be_valid
      end
    end
  end
end
