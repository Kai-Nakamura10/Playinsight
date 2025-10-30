class RulesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :search ]
  def show
    @rule = Rule.find(params[:id])
    @next_rule = Rule.where("id > ?", @rule.id).order(:id).first
  end

  def search
    if params[:q].present?
      @rules = Rule.where("title ILIKE ? OR body ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
    else
      @rules = Rule.none
    end
  end
end
