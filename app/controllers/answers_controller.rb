# frozen_string_literal: true

class AnswersController < ApplicationController
  def index
    redirect_to question_path Question.find(params[:question_id])
  end

  def show; end

  def new
    question = Question.find(params[:question_id])
    redirect_to question_path(question)
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@question)
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
