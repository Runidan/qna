require 'rails_helper'

RSpec.feature 'User voting for a votable (question/answer)', type: :feature do
  given(:user) { create(:user) }
  given(:user2) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: other_user) }
  given!(:answer) { create(:answer, question: question, user: other_user) }
  
  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'Authenticated user votes for a liked question', js: true do
    within '.question' do
      click_on '+'

      expect(page).to have_content('1')
    end
  end

  scenario 'User can not vote for his own question', js: true do
    question.update(user: user) # Make the authenticated user an author
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link('+')
      expect(page).not_to have_link('-')
    end
  end

  scenario 'User votes for a question only once', js: true do
    within '.question' do
      click_on '+'
      expect(page).to have_content('1')
      
      expect(page).not_to have_link('+')
    end
  end

  scenario 'User can cancel their decision and revote', js: true do
    within '.question' do
      click_on '+'
      click_on 'Unvote'
      expect(page).to have_content('0')
      
      click_on '-'
      expect(page).to have_content('-1')
    end
  end
  
  scenario 'Resulting rating is displayed for a question', js: true do
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
