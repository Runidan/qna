require 'rails_helper'

feature 'Answering a question' do

  describe "aunticated user" do
    given(:user) { create(:user) }

    background do
      question = create(:question)
      sign_in(user)
      visit question_path(question)
    end

    scenario ' can answer a question' do
      fill_in 'Body', with: 'This is my answer'
      click_on 'Answer'
      expect(page).to have_content('This is my answer')
    end

    scenario "can't send null answer" do
      click_on 'Answer'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "unaunticated user can't answer a question" do
    question = create(:question)
    visit question_path(question)
    expect(page).to have_no_field('Body')
  end
end