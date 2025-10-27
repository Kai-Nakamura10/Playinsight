class TacticsController < ApplicationController
  def show
    @tactic = Tactic.find(params[:id])
    scope = Tactic.order(:id)

    @next_tactic = scope.where("id > ?", @tactic.id).first || scope.first
    @prev_tactic = scope.where("id < ?", @tactic.id).last  || scope.last
  end
end
