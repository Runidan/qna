# frozen_string_literal: true

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional information to my answer
  As an authenticated author
  I'd like to be able to add links to answer
" do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/Runidan/d3b0b5471f574bf20e2664907216e61d' }

  scenario 'User can add links to answer', :js do
    sign_in user

    visit question_path(question)

    fill_in 'Body',	with: 'My answer'

    fill_in 'Link name',	with: 'My gist'
    fill_in 'Url',	with: gist_url
    click_on 'Answer'
    within '.your-answer' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
