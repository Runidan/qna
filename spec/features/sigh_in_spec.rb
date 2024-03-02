require 'rails_helper'

feature "User can sing in", %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sigh in
} do
  scenario 'Registered user tries to sigh in' do
    User.create!(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.ru' 
    fill_in 'Password', with: '12345678'

    expect(page).to have_content 'Signed in successfully.'
  end

  scenario 'Unregistered user tries to sigh in'
end