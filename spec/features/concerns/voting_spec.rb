# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'User voting for a votable (question/answer)' do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: other_user) }
  given(:user_question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question:, user: other_user) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user votes for a liked question', :js do
    within '.question' do
      click_on '+'

      expect(page).to have_content('1')
    end
  end

  scenario 'User can not vote for his own question', :js do

    visit question_path(user_question)

    within '.question' do
      expect(page).to have_no_link('+')
      expect(page).to have_no_link('-')
    end
  end

  scenario 'User votes for a question only once', :js do
    within '.question' do
      click_on '+'
      expect(page).to have_content('1')

      expect(page).to have_no_link('+')
    end
  end

  scenario 'User can cancel their decision and revote', :js do
    within '.question' do
      click_on '+'
      click_on 'Unvote'
      expect(page).to have_content('0')

      click_on '-'
      expect(page).to have_content('-1')
      click_on 'Unvote'
      expect(page).to have_content('0')
    end
  end

  scenario 'Resulting rating is displayed for a question', :js do
    within '.question' do
      click_on '+'
      expect(page).to have_content('1')
    end

    click_on 'Log out'
    sign_in(user2)
    visit question_path(question)

    within '.question' do
      click_on '-'
      expect(page).to have_content('0')
    end
  end
end
