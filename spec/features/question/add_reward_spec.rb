require 'rails_helper'

feature 'User can add rewars to questions for best answer', %q{ 
  In order to provide additional information to my question
  As an authenticated author
  I'd like to be able to add reward to questions for best answer
} do
  given(:user) { create(:user) }

  background do
    sign_in user
    visit new_question_path

    fill_in 'Title', with: "My question's title"
    fill_in "Body",	with: "sometext" 

    
  end
  
  scenario 'User can add reward to questions for best answer' do

    within('.set-reward') do
      fill_in 'Name', with: "Reward Name"
      attach_file 'Image', "#{Rails.root}/spec/fixture/files/reward_image.jpg"
    end
    

    click_on "Ask"

    expect(page).to have_content("Reward Name")
    expect(page).to have_selector("img[src$='reward_image.jpg']")

  end

  scenario "User can't add reward with name only" do

    within('.set-reward') do
      fill_in 'Name', with: "Reward Name"
    end
    

    click_on "Ask"

    expect(page).to have_content("Reward image can't be blank")

  end

  scenario "User can't add reward with image only" do

    within('.set-reward') do
      attach_file 'Image', "#{Rails.root}/spec/fixture/files/reward_image.jpg"
    end
    

    click_on "Ask"

    expect(page).to have_content("Reward name can't be blank")

  end

  scenario "User can't add reward with not jpeg or png image" do

    within('.set-reward') do
      fill_in 'Name', with: "Reward Name"
      attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"
    end
    

    click_on "Ask"

    expect(page).to have_content("Reward image has an invalid content type")

  end

end
