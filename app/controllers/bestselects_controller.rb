class BestselectsController < ApplicationController
  before_action :set_bestselect, only: [ :show, :answer ]

  def show
    @bestselect = Bestselect.find(params[:id])

    # 次の問題
    @next_bestselect =
      Bestselect.where("created_at > ?", @bestselect.created_at)
                .order(:created_at)
                .first || Bestselect.order(:created_at).first

    # 戦術の取得（必須）
    @tactic = @bestselect.tactic

    # ユーザーが前に回答した選択肢（あれば）
    @selected_choice =
      BestselectAnswer.where(user: current_user, bestselect: @bestselect)
                      .order(created_at: :desc)
                      .first&.answer
    if user_signed_in?
      @correct = current_user.correct_answers_count
      @total = current_user.total_answers_count
    else
      @correct = 0
      @total = 0
    end
  end

  # POST /bestselects/:id/answer
  def answer
    @bestselect = Bestselect.find(params[:id])
    selected_answer = Answer.find(params[:choice_id])

    # 認証チェック
    unless user_signed_in?
      render json: { error: 'ログインが必要です' }, status: 401
      return
    end

    # ユーザーの回答を保存（既存のものは更新）
    user_answer = UserAnswer.find_or_initialize_by(
      user: current_user,
      bestselect: @bestselect
    )
    user_answer.answer = selected_answer
    
    if user_answer.save
      # 統計データを返す
      render json: {
        correct: user_answer.is_correct,
        correct_count: current_user.correct_answers_count,
        total_count: current_user.total_answers_count,
        accuracy_rate: current_user.accuracy_rate
      }
    else
      render json: { error: user_answer.errors.full_messages }, status: 422
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: '不正なリクエストです' }, status: 422
  end

  private

  def set_bestselect
    @bestselect = Bestselect.find(params[:id])
  end
end
