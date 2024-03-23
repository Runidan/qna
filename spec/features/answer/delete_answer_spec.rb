# frozen_string_literal: true

require 'rails_helper'

feature 'Deleting answers.' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }

  background do
    sign_in(user)
  end

  scenario 'Author can delete their own answer' do
    visit question_path(question)
    within("#answer-#{answer.id}") do
      click_on 'Delete Answer'
    end
    
    expect(page).to have_content('Answer was successfully deleted.')
    expect(page).to have_no_content(answer.body)
  end

  scenario 'User cannot delete another user\'s answer' do
    other_user = create(:user)
    other_answer = create(:answer, question:, user: other_user)

    visit question_path(question)

    within("#answer-#{other_answer.id}") do
      expect(page).to have_no_content('Delete Answer')
    end
  end
end
