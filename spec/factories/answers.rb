# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "Answer №#{n}" }
  end

  trait :invalid do
    body { nil }
  end
end
