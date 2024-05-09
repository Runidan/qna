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
      fill_in 'answer_body', with: 'This is the answer body text.'

      click_on 'Answer'
      expect(page).to have_content('This is the answer body text.')
    end

    scenario "can't send null answer" do
      count_answers_before = page.all('.answers-list').size
      click_on 'Answer'
      expect(page.all('.answers-list').size).to eq count_answers_before
      expect(page).to have_content("Body is too short")
    end

    scenario 'can add file to his anwer' do
      fill_in 'answer_body', with: 'This is the answer body text.'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'
      expect(page).to have_content('This is the answer body text.')
      visit current_path
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario "Unaunticated user can't answer a question" do
    question = create(:question)
    visit question_path(question)
    expect(page).to have_no_field('Body')
  end
end
