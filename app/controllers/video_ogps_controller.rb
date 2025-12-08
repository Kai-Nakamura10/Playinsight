class VideoOgpsController < ApplicationController
  skip_before_action :authenticate_user!, only: :show

  def show
    @video = Video.find_by(id: params[:id])
    return head :not_found if @video.nil? || @video.visibility_private?
  end
end
