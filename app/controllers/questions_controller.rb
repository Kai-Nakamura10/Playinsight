class QuestionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :answer ]

  def show
    @question = Question.includes(:choices).find(params[:id])
    @choices  = @question.choices.order(:id).to_a
    @next_question = @question.next

    choice_id = params[:choice_id].presence
    return unless choice_id

    @selected_choice = @choices.find { |c| c.id == choice_id.to_i }
    return unless @selected_choice

    @attempt = QuestionAttempt
      .where(question_id: @question.id, choice_id: @selected_choice.id)
      .order(created_at: :desc)
      .first

    @ai = @attempt&.explanation_json&.deep_symbolize_keys
  end

  def answer
    @question = Question.includes(:choices).find(params[:id])
    @choices  = @question.choices.order(:id).to_a
    @next_question = @question.next

    if params[:choice_id].blank?
      flash.now[:alert] = "選択肢を選んでください。"
      render :show, status: :unprocessable_entity and return
    end

    @selected_choice = @choices.find { |c| c.id == params[:choice_id].to_i }
    unless @selected_choice
      flash.now[:alert] = "不正な選択肢が選ばれました。"
      render :show, status: :unprocessable_entity and return
    end

    is_correct = @selected_choice.is_correct?

    # 既存 Attempt（最新）を取得
    attempt = QuestionAttempt
      .where(question_id: @question.id, choice_id: @selected_choice.id)
      .order(created_at: :desc)
      .first

    unless attempt
      # インデックス計算は配列から一度で
      correct_idx0 = @choices.index { |c| c.is_correct? }
      selected_idx0 = @choices.index(@selected_choice)

      # 正解未設定の安全策
      correct_index = correct_idx0 ? correct_idx0 + 1 : nil
      selected_index = selected_idx0 ? selected_idx0 + 1 : nil

      # 念のためのバリデーション
      if correct_index.nil?
        Rails.logger.warn("[QuestionsController#answer] correct_index is nil (question_id=#{@question.id})")
      end
      if selected_index.nil?
        Rails.logger.warn("[QuestionsController#answer] selected_index is nil (question_id=#{@question.id}, choice_id=#{@selected_choice.id})")
      end

      choices_texts = @choices.map(&:body)

      json, latency_ms, model = AiAnswerExplainer.call(
        question_text:  @question.content,
        choices_texts:  choices_texts,
        correct_index:  correct_index,
        selected_index: selected_index
      )

      # 重複作成を避けたいなら DB ユニーク制約を推奨（後述）
      attempt = QuestionAttempt.create!(
        question:        @question,
        choice:          @selected_choice,
        is_correct:      is_correct,
        explanation_json: json,
        ai_model_name:   model,
        latency_ms:      latency_ms
      )
    end

    redirect_to question_path(@question, choice_id: @selected_choice.id), status: :see_other
  end
end
