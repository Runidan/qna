# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy set_best_answer]
  before_action :authorize_user!, only: %i[edit update destroy set_best_answer]

  def index
    @questions = Question.all
  end

  def show
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer = @question.answers.build
  end

  def new
    @question = Question.new
    @question.links.build
  end

  def edit; end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      flash[:success] = 'Your question successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      flash[:success] = 'Question was successfully updated.'
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.destroy
      flash[:success] = 'Question was successfully deleted.'
      redirect_to questions_path
    else
      render :show
    end
  end

  def set_best_answer
    best_answer = Answer.find(params[:best_answer_id])

    if @question.answers.include?(best_answer)
      @question.update(best_answer:)
      flash[:success] = 'Best answer has been set.'
      redirect_to question_path(@question)
    else
      head :forbidden
    end
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :best_answer_id, files: [], :links_attributes => %i[name url])
  end

  def authorize_user!
    return if current_user&.author_of?(@question)

    head :forbidden
  end
end
