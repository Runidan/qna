# frozen_string_literal: true

require 'rails_helper'

feature 'Viewing a question and its answers' do
  scenario 'user can view a question and its answers' do
    # Создаем вопрос и ответы
    question = create(:question)
    answers = create_list(:answer, 3, question:)

    visit question_path(question)

    expect(page).to have_content(question.title)
    expect(page).to have_content(question.body)

    answers.each do |answer|
      expect(page).to have_content(answer.body)
    end
  end
end
