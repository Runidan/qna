require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) } 

  it { should have_db_column(:title).of_type(:string) }
  it { should validate_presence_of(:title) }
  it { should have_db_column(:body).of_type(:text) }
  it { should validate_presence_of(:body) }
end
