# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    user
    name { 'User Name' }
  end
end
