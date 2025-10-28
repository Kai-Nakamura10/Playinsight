class RulesController < ApplicationController
  def show
    @rule = Rule.find(params[:id])
    @next_rule = Rule.where("id > ?", @rule.id).order(:id).first
  end
end
