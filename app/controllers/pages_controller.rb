class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :how_to ]
  def how_to;end
end
