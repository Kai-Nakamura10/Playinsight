class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_header_rule
  before_action :set_header_tactic

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,        keys: %i[nickname])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[nickname])
  end

  private

  def set_header_rule
    @rule = Rule.first
  end

  def set_header_tactic
    @tactic = Tactic.first
  end
end
