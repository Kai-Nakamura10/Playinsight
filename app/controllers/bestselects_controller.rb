class BestselectsController < ApplicationController
  def index
    @bestselect = Bestselect.includes(:answers).first
  end

  def show
    @bestselect = Bestselect.find(params[:id])
    @next_bestselect = Bestselect.where("id > ?", @bestselect.id).order(:id).first || Bestselect.order(:id).first
  end
end
