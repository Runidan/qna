# frozen_string_literal: true

require 'rails_helper'

feature 'Log in' do
  scenario 'user can log in with valid params' do
    user = create(:user)

    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_on 'Log in'

    expect(page).to have_current_path(root_path, ignore_query: true)
    expect(page).to have_content('Signed in successfully.')
  end
end
