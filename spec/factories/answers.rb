# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer №#{n}" }

  end

  trait :invalid_answer do
    body { nil }
  end
end
