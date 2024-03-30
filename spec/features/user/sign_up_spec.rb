# frozen_string_literal: true

require 'rails_helper'

feature 'Sign up' do
  scenario 'user can sign up successfully' do
    visit new_user_registration_path

    fill_in 'Email', with: 'test@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'

    click_on 'Sign up'

    expect(page).to have_current_path(root_path, ignore_query: true)
    expect(page).to have_content('Welcome! You have signed up successfully.')
  end
end
