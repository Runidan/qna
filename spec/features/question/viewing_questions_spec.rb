require 'rails_helper'

feature 'Viewing questions' do
  # Создаем тестового пользователя
  given(:user) { create(:user) }

  # Создаем несколько тестовых вопросов
  given(:questions) { create_list(:question, 3) }

  scenario 'user can see a list of questions' do
    # Посещаем страницу со списком вопросов
    visit questions_path

    # Проверяем, что отображается заголовок страницы
    expect(page).to have_content('Questions')

    # Проверяем, что отображается список вопросов
    questions.each do |question|
      expect(page).to have_content(question.title)
    end

    # Проверяем, что отображается ссылка на страницу создания вопроса
    expect(page).to have_link('Ask question')
  end
end