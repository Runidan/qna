# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question №#{n}" }
    sequence(:body) { |n| "Body for question №#{n}" }

    user factory: %i[user]

    trait :invalid do
      title { nil }
    end
  end
end
