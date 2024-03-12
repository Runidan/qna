# frozen_string_literal: true

require 'rails_helper'

feature 'Deleting questions.' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user:) }

  background do
    sign_in(user)
  end

  scenario 'Author can delete their own question' do
    visit question_path(question)

    click_on 'Delete Question'

    expect(page).to have_content('Question was successfully deleted.')
    expect(page).to have_no_content(question.title)
  end

  scenario 'author cannot delete another user\'s question' do
    other_user = create(:user)
    other_question = create(:question, user: other_user)

    visit question_path(other_question)

    expect(page).to have_no_content('Delete Question')
  end
end
