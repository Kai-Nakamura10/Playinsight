class VideosController < ApplicationController
  def index
    if params[:tag_id].present?
      tag = Tag.find(params[:tag_id])
      @videos = tag.videos
                   .includes(:user)
                   .with_attached_file
                   .with_attached_thumbnail
                   .order(created_at: :desc)
    else
      @videos = Video.includes(:user).with_attached_file.with_attached_thumbnail.order(created_at: :desc)
    end
  end

  def new
    @video = Video.new
  end

  def show
    @video = Video.includes(:tags).find(params[:id])
    @comment_tree = @video.comments.order(:created_at).arrange
    @new_comment = @video.comments.new
  end

  def edit
    @video = current_user.videos.find(params[:id])
  end

  def update
    @video = current_user.videos.find(params[:id])
    if @video.update(video_params)
      redirect_to video_path(@video)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @video = current_user.videos.find(params[:id])
    @video.destroy!
    redirect_to videos_path
  end

  def create
    @video = current_user.videos.new(video_params)
    if @video.save
      redirect_to video_path(@video)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def video_params
    params.require(:video).permit(:title, :description, :visibility, :file, :thumbnail)
  end
end
