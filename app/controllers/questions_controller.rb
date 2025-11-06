class QuestionsController < ApplicationController
  def show
    @question = Question.includes(:choices).find(params[:id])
  end

  def answer
    @question = Question.includes(:choices).find(params[:id])
    @selected_choice = @question.choices.find(params[:choice_id])
    render :show
  end
end
