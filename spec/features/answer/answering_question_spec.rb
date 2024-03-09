require 'rails_helper'

feature 'Answering a question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'aunticated user can answer a question' do
    
    sigh_in(user)
    visit question_path(question)
    fill_in 'Body', with: 'This is my answer.'
    click_on 'Answer'

    expect(page).to have_content('This is my answer.')
  end

  scenario "unaunticated user can't answer a question" do
    visit question_path(question)
    expect(page).to have_no_field('Body')
  end
end