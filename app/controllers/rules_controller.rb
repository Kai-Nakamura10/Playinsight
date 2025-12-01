class RulesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :search ]

  def show
    @rule = Rule.find(params[:id])
    @next_rule = Rule.where("created_at > ?", @rule.created_at).order(:created_at).first || Rule.order(:created_at).first
  end

  def search
    @rules = params[:q].present? ? Rule.where("title ILIKE ? OR body ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") : Rule.none
    respond_to do |format|
      format.html
      format.json do
        render json: @rules.limit(8).map { |rule| { title: rule.title, url: rule_path(rule) } }
      end
    end
  end
end
