# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index destroy]
  before_action :load_answer, only: %i[destroy]
  before_action :load_question, only: %i[index create]

  def index
    redirect_to question_path @question
  end

  def create
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user

    if @answer.save
      flash[:success] = 'Answer was  successfully added.'
      redirect_to question_path(@question, anchor: "answer-#{@answer.id}")
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user&.author_of?(@answer) && @answer.destroy
      flash[:success] = 'Answer was successfully deleted.'
      redirect_to question_path(@answer.question)
    else
      render 'questions/show'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end
end
