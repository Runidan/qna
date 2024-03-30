# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index destroy]
  before_action :load_answer, only: %i[update destroy]
  before_action :load_question, only: %i[index create]
  before_action :authorize_user!, only: %i[update destroy]

  def index
    redirect_to question_path @question
  end

  def create
    params_with_user_id = answer_params.merge(user_id: current_user.id)
    @answer = @question.answers.create(params_with_user_id)
  end

  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    @answer.destroy
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [])
  end

  def load_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def authorize_user!
    return if current_user&.author_of?(@answer)

    head :forbidden
  end
end
