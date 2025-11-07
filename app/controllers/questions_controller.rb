class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :answer ]
  def show
    @question = Question.includes(:choices).find(params[:id])
    @choices  = @question.choices.order(:id)
    @next_question = @question.next

    if params[:choice_id].present?
      @selected_choice = @question.choices.find_by(id: params[:choice_id])
    elsif flash[:choice_id].present?
      @selected_choice = @question.choices.find_by(id: flash[:choice_id])
    end
  end

  def answer
    @question = Question.includes(:choices).find(params[:id])

    if params[:choice_id].blank?
      @choices  = @question.choices.order(:id)
      @next_question = @question.next
      flash.now[:alert] = "選択肢を選んでください。"
      render :show, status: :unprocessable_entity and return
    end

    @selected_choice = @question.choices.find_by(id: params[:choice_id])
    unless @selected_choice
      @choices  = @question.choices.order(:id)
      @next_question = @question.next
      flash.now[:alert] = "不正な選択肢が選ばれました。"
      render :show, status: :unprocessable_entity and return
    end

    redirect_to question_path(@question, choice_id: @selected_choice.id), status: :see_other
  end
end
