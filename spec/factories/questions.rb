# frozen_string_literal: true

FactoryBot.define do
  sequence :title do |n|
    "Question №#{n}"    
  end

  sequence :body do |n|
    "Body for question №#{n}"    
  end

  factory :question do
    title
    body

    trait :invalid do
      title { nil }
    end
  end
end
