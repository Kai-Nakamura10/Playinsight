class TacticsController < ApplicationController
  def show
    @tactic = Tactic.find(params[:id])
  end
end
