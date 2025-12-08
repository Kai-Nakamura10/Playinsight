class VideoOgpsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @video = Video.find_by(id: params[:id])
    unless @video && !@video.visibility_private?
      head :not_found
    end
  end
end
