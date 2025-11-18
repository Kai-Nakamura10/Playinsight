class RulesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :search ]
  def show
    @rule = Rule.find(params[:id])
    @next_rule = Rule.where("id > ?", @rule.id).order(:id).first
  end

  def search
    @rules = params[:q].present? ? Rule.where("title ILIKE ? OR body ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") : Rule.none
    respond_to do |format|
      format.html
      format.json { render json: @rules.limit(8).map(&:title) }
    end
  end
end
