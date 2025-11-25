class BestselectsController < ApplicationController
  before_action :set_bestselect, only: [:show, :answer]

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

    # 正解率集計（ログイン時のみ）
    if current_user && @tactic
      related_bestselects = Bestselect.where(tactic: @tactic)

      answers = BestselectAnswer.where(
        user: current_user,
        bestselect: related_bestselects
      )

      @correct = answers.where(is_correct: true).count
      @total   = answers.count
      @accuracy = @total.zero? ? 0 : (@correct.to_f / @total)
    end
  end

  # POST /bestselects/:id/answer
  def answer
    choice = @bestselect.answers.find(params[:choice_id])

    BestselectAnswer.create!(
      user: current_user,
      bestselect: @bestselect,
      answer: choice,
      is_correct: choice.is_correct
    )

    render json: { status: "ok" }
  end

  private

  def set_bestselect
    @bestselect = Bestselect.find(params[:id])
  end
end
