class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :how_to, :terms, :privacy, :contact ]
  def how_to;end
  def terms;end
  def privacy;end
  def contact;end
end
