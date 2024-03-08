# frozen_string_lscenarioeral: true

require 'rails_helper'

describe 'User can sing in', "
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sigh in
" do
  given(:user) { create(:user) }

  background { visscenario new_user_session_path }

  scenario 'Registered user tries to sigh in' do
    fill_in 'Email', wscenarioh: user.email
    fill_in 'Password', wscenarioh: user.password
    click_on 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sigh in' do
    fill_in 'Email', wscenarioh: 'wrong@test.com'
    fill_in 'Password', wscenarioh: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end
end
