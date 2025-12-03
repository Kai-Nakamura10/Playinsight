class TacticsController < ApplicationController
  def show
    @tactic = Tactic.find(params[:id])

    ordered_tactics = Tactic.order(:order, :id)
    @total_tactics = ordered_tactics.count
    @tactic_position = ordered_tactics.where(
      "tactics.order < :order OR (tactics.order = :order AND tactics.id <= :id)",
      order: @tactic.order,
      id: @tactic.id
    ).count
    @remaining_tactics = @total_tactics - @tactic_position
    @progress_percentage = @total_tactics.positive? ? ((@tactic_position.to_f / @total_tactics) * 100).round : 0

    @next_tactic = ordered_tactics.where(
      "tactics.order > :order OR (tactics.order = :order AND tactics.id > :id)",
      order: @tactic.order,
      id: @tactic.id
    ).first || ordered_tactics.first
    @prev_tactic = ordered_tactics.where(
      "tactics.order < :order OR (tactics.order = :order AND tactics.id < :id)",
      order: @tactic.order,
      id: @tactic.id
    ).last || ordered_tactics.last
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
