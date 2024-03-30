# frozen_string_literal: true

require 'rails_helper'

feature 'Editing question' do
  context 'when authenticated user' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question, user_id: user.id) }

    background do
      sign_in(user)
    end

    scenario 'can edit his question' do
      visit question_path(question)
      click_on 'Edit question'

      fill_in 'Title',	with: 'new question title'
      fill_in 'Body',	with: 'new question body'

      click_on 'Save'

      expect(page).to have_content 'new question title'
      expect(page).to have_content 'new question body'
    end

    scenario 'can add and delete files to his question', :js do
      visit edit_question_path(question)
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Save'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'

      visit edit_question_path(question)

      within '.attached-files' do
        expect(page).to have_css('li', count: 2)
        first('a[data-method="delete"]').click
        accept_confirm 'Are you sure?'
        expect(page).to have_css('li', count: 1)
      end
    end
  end
end
