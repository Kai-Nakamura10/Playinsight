class CommentsController < ApplicationController
  before_action :set_video, only: [ :create ]
  before_action :set_comment, only: [ :destroy ]
  def create
    if comment_params[:parent_id].present?
      parent = @video.comments.find(comment_params[:parent_id])
      @comment = parent.children.build(comment_params.except(:parent_id))
    else
      @comment = @video.comments.build(comment_params.except(:parent_id))
    end
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to video_path(@video), notice: "Comment created successfully." }
      else
        format.turbo_stream { render "videos/show", status: :unprocessable_entity }
        format.html { render "videos/show", status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to video_path(@comment.video), notice: "Comment deleted." }
    end
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end

  def set_comment
    @comment = current_user.comments.find(params[:id])
  end

  def comment_params
    params
      .require(:comment)
      .permit(:body, :parent_id, :timeline_id, :video_timestamp_seconds)
      .merge(video_id: params[:video_id])
  end
end
