FactoryBot.define do
  factory :profile do
    association :user
    name { "User Name" }
  end
end
