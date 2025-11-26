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

    # 次の問題（next）が存在すればそのIDを返す
    next_bestselect = @bestselect.next
    next_id = next_bestselect&.id

    # ここが重要：必ず JSON を返す
    render json: {
      status: "ok",
      next_id: next_id,
      correct: choice.is_correct
    }
  end

  private

  def set_bestselect
    @bestselect = Bestselect.find(params[:id])
  end
end
