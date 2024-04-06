require 'rails_helper'

feature 'User can add links to questions', %q{ 
  In order to provide additional information to my question
  As an authenticated author
  I'd like to be able to add links to questions
} do
  given(:user) { create(:user) }
  given(:gist_url) { "https://gist.github.com/Runidan/d3b0b5471f574bf20e2664907216e61d" }

  scenario 'User can add links to questions' do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: "My question's title"
    fill_in "Body",	with: "sometext" 

    fill_in "Link name",	with: "My gist" 
    fill_in "Url",	with: gist_url 

    click_on "Ask"

    expect(page).to have_link "My gist", href: gist_url

  end
end