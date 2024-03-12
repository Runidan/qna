# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer №#{n}" }

    user factory: %i[user]
  end

  trait :invalid_answer do
    body { nil }
  end
end
