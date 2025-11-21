class BestselectsController < ApplicationController
  def index
    @bestselect = Bestselect.includes(:answers).first
  end

  def show
    @bestselect = Bestselect.find(params[:id])
    @next_bestselect = Bestselect.where("created_at > ?", @bestselect.created_at).order(:created_at).first || Bestselect.order(:created_at).first
  end
end
