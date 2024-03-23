 require 'rails_helper'

 feature 'User can edit his answer', %q{
  In order to correct mistekes
  As an author of answer
  I'd like to be able to edit my answer
 } do

    given!(:user) { create(:user) }
    given!(:question) { create(:question)}
    given!(:answer) { create(:answer, question: question, user_id: user.id)}
    
    scenario 'Unauthenticated can not edit answer ', js: true do
      visit question_path(question)

      expect(page).not_to have_link "Edit" 
    end

    describe 'Authenticated user', js: true do
      scenario 'edit his answer' do
        sign_in user
        visit question_path(question)

        click_on 'Edit'

        within '.answers-list' do
          fill_in 'Body', with: 'edited answer'
          click_on 'Save'  

          expect(page).not_to have_content answer.body
          expect(page).to have_content 'edited answer'
          expect(page).not_to have_selector 'textarea'
        end
      end
      scenario 'edit his answer with error'
      scenario "tries to edit other user's question"
    end
 end