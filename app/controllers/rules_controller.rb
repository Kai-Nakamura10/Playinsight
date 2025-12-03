class RulesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :show, :search ]

  def show
    @rule = Rule.find(params[:id])

    ordered_rules = Rule.order(:created_at, :id)
    @total_rules = ordered_rules.count
    @rule_position = ordered_rules.where("created_at < :created_at OR (created_at = :created_at AND id <= :id)", created_at: @rule.created_at, id: @rule.id).count
    @remaining_rules = @total_rules - @rule_position
    @progress_percentage = @total_rules.positive? ? ((@rule_position.to_f / @total_rules) * 100).round : 0

    @next_rule = ordered_rules.where("created_at > :created_at OR (created_at = :created_at AND id > :id)", created_at: @rule.created_at, id: @rule.id).first || ordered_rules.first
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
