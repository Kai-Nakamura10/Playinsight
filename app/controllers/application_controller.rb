class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_header_rule
  before_action :set_header_tactic
  before_action :set_header_question
  before_action :set_header_faq
  before_action :set_header_bestselect

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: %i[nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[nickname])
  end

  private

  def set_header_rule
    @header_rule = Rule.order(:created_at).first
  end

  def set_header_tactic
    @header_tactic = Tactic.order(:created_at).first
  end

  def set_header_question
    @header_question = Question.order(:created_at).first
  end

  def set_header_faq
    @header_faq = Faq.order(:created_at).first
  end

  def set_header_bestselect
    @header_bestselect = Bestselect.order(:created_at).first
  end
end
