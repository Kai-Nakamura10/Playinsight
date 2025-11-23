class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :how_to, :terms ]
  def how_to;end
  def terms;end
end
