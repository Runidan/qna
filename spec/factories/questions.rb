# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "Question №#{n}" }
    sequence(:body) { |n| "Body for question №#{n}" }

    user

    after(:create) do |question, evaluator|
      evaluator.files.each do |file|
        question.files.attach(file)
      end
    end

    trait :invalid do
      title { nil }
    end
  end
end
