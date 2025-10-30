class VideoTacticsController < ApplicationController
  def create
    vt = VideoTactic.new(video_tactic_params)
    if vt.save
      redirect_to video_path(vt.video_id), notice: "戦術を追加しました。"
    else
      redirect_back fallback_location: video_path(vt.video_id),
                    alert: vt.errors.full_messages.join(", ")
    end
  end

  def update
    vt = VideoTactic.find(params[:id])
    if vt.update(video_tactic_params)
      redirect_to video_path(vt.video_id), notice: "時間を更新しました。"
    else
      redirect_back fallback_location: video_path(vt.video_id),
                    alert: vt.errors.full_messages.join(", ")
    end
  end

  def destroy
    vt = VideoTactic.find(params[:id])
    video_id = vt.video_id
    vt.destroy
    redirect_to video_path(video_id), notice: "削除しました。"
  end

  private

  def video_tactic_params
    params.require(:video_tactic).permit(:video_id, :tactic_id, :display_time)
  end
end
