# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistekes
  As an author of answer
  I'd like to be able to edit my answer
 " do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question:, user_id: user.id) }
  given(:other_user) { create(:user) }
  given!(:other_answer) { create(:answer, question:, user_id: other_user.id) }

  scenario 'Unauthenticated can not edit answer', :js do
    visit question_path(question)

    expect(page).to have_no_link 'Edit'
  end

  describe 'Authenticated user' do
    background do
      sign_in user
      visit question_path(question)
    end

    scenario 'edit his answer, add and delete files', :js do
      click_on 'Edit'

      within "article#answer-#{answer.id}" do
        fill_in 'Body', with: 'edited answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_no_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to have_no_css 'textarea'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'

        expect(page).to have_css('li.attached-file', count: 2)
        first('a[data-method="delete"]').click
        accept_confirm 'Are you sure?'
        expect(page).to have_css('li.attached-file', count: 1)
      end
    end

    scenario 'edit his answer with error', :js do
      within "article#answer-#{answer.id}" do
        click_on 'Edit'
        fill_in 'Body', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
        expect(page).to have_css 'textarea'
      end
    end

    scenario 'tries to cancel editing an answer', :js do
      within "article#answer-#{answer.id}" do
        click_on 'Edit'
        click_on 'Cancel'

        expect(page).to have_no_css("form#edit-answer-#{answer.id}")
        expect(page).to have_css('.edit-answer-link', visible: true)
      end
    end

    scenario "tries to edit other user's question", :js do
      within "article#answer-#{other_answer.id}" do
        expect(page).to have_content(other_answer.body)
        expect(page).to have_no_link('Edit')
      end
    end
  end
end
