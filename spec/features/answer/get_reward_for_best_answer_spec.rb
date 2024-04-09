# frozen_string_literal: true

require 'rails_helper'

feature 'Marking best answer', :js do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user:) }
  given!(:answer) { create(:answer, question:, user:) }

  describe 'Author of answer' do

    scenario 'getting reward for best answer' do
      sign_in(user)
      visit edit_question_path(question)

      within('.set-reward') do
        fill_in 'Name', with: "Reward Name"
        attach_file 'Image', "#{Rails.root}/spec/fixture/files/reward_image.jpg"
      end
      
      click_on "Save"

      within "#answer-#{answer.id}" do
        click_on 'Mark as best'
      end

      expect(page).to have_content 'Best answer has been set.'

      visit profile_path(user.profile)
      expect(page).to have_content("Reward Name")
      expect(page).to have_selector("img[src$='reward_image.jpg']")


    end
  end
end
