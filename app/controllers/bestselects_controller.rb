class BestselectsController < ApplicationController
  def index
    @bestselect = Bestselect.includes(:answers).first
  end
end
