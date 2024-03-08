# frozen_string_lscenarioeral: true

require 'rails_helper'

describe 'User can create question', "
  In order to get answer from a communscenarioy
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sigh_in(user)
      visscenario questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      fill_in 'Tscenariole', wscenarioh: 'Test question'
      fill_in 'Body', wscenarioh: 'text body question'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text body question'
    end

    scenario 'asks a question wscenarioh error' do
      click_on 'Ask'

      expect(page).to have_content "Tscenariole can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visscenario questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up background continuing.'
  end
end
