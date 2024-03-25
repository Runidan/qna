# frozen_string_literal: true

require 'rails_helper'

feature 'Answering a question.' do
  describe 'Authinticated user', :js do
    given(:user) { create(:user) }

    background do
      question = create(:question, user:)
      sign_in(user)
      visit question_path(question)
    end

    scenario 'can answer a question' do
      within('.field') do
        fill_in 'answer_body', with: 'This is the answer body text.'
      end
      click_on 'Answer'
      expect(page).to have_content('This is the answer body text.')
    end

    scenario "can't send null answer" do
      count_answers_before = page.all('.answers-list').size
      click_on 'Answer'
      expect(page.all('.answers-list').size).to eq count_answers_before
      expect(page).to have_content("Body can't be blank")
    end
  end

  scenario "Unaunticated user can't answer a question" do
    question = create(:question)
    visit question_path(question)
    expect(page).to have_no_field('Body')
  end
end
