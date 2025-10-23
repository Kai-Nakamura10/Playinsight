class BestselectsController < ApplicationController
  def index
    @bestselect = Bestselect.includes(:answers).first
  end

  def show
    @bestselect = Bestselect.find(params[:id])
  end
end
