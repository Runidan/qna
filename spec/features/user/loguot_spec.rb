# frozen_string_literal: true

require 'rails_helper'

feature 'Sign out' do
  scenario 'user can sign out' do
    user = create(:user)

    sign_in user

    visit root_path

    click_on 'Log out'

    expect(page).to have_current_path(root_path, ignore_query: true)
    expect(page).to have_content('Login')
    expect(page).to have_no_content(user.email)
  end
end
