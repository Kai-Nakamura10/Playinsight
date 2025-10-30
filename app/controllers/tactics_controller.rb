class TacticsController < ApplicationController
  def show
    @tactic = Tactic.find(params[:id])
    scope = Tactic.order(:id)

    @next_tactic = scope.where("id > ?", @tactic.id).first || scope.first
    @prev_tactic = scope.where("id < ?", @tactic.id).last  || scope.last
  end

  def index
    @tactics = Tactic.order(:title)
  end

  def new
    @tactic = Tactic.new
  end

  def create
    @tactic = Tactic.new(tactic_params)
    if @tactic.save
      redirect_to edit_tactic_path(@tactic), notice: "戦術を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tactic = Tactic.find(params[:id])
    @tactic.success_text  = @tactic.success_conditions.join("\n")
    @tactic.failure_text  = @tactic.common_failures.join("\n")
    @tactic.counters_text = @tactic.counters_string
  end

  def update
    @tactic = Tactic.find(params[:id])

    if @tactic.update(tactic_params)
      redirect_to edit_tactic_path(@tactic), notice: "戦術を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def tactic_params
    params.require(:tactic).permit(
      :title, :description, :trigger, :slug,
      :success_text, :failure_text, :counters_text
    )
  end
end
