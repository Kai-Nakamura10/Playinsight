class VideoOgpsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @video = Video.find(params[:id])
    head :not_found if @video.visibility_private?
  end
end
