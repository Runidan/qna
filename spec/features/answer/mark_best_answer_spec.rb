# frozen_string_literal: true

require 'rails_helper'

feature 'Marking best answer', :js do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }
  given(:other_user) { create(:user) }

  describe 'Author' do
    background do
      sign_in(user)
    end

    scenario 'can mark an answer as the best' do
      visit question_path(question)

      within "#answer-#{answer.id}" do
        click_on 'Mark as best'
      end

      expect(page).to have_content 'Best answer has been set.'

      within '.best-answer' do
        expect(page).to have_content answer.body
      end

    end
  end

  scenario "Non-author can't mark an answer as the best" do
    sign_in other_user
    visit question_path(question)
    expect(page).to have_no_content 'Mark as best'
  end
end
