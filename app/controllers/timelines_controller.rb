class TimelinesController < ApplicationController
  before_action :set_video, only: %i[new create all]
  before_action :set_timeline, only: %i[show edit update destroy]

  def all
    timelines = @video.timelines.order(:start_seconds)
    render json: timelines.as_json(only: %i[id kind start_seconds end_seconds title body payload])
  end

  def new
    @timeline = @video.timelines.new
  end

  def create
    mapped_attrs = map_params_to_model(timeline_params)
    @timeline = @video.timelines.new(mapped_attrs.merge(video: @video))

    if @timeline.save
      @timelines = @video.timelines.order(:start_seconds)
      respond_to do |format|
        format.html { redirect_to video_path(@video), notice: "タイムラインを追加しました。" }
        format.turbo_stream
      end
    else
      redirect_to video_path(@video), alert: "タイムラインの追加に失敗しました。"
    end
  end

  def edit; end

  def update
    mapped_attrs = map_params_to_model(timeline_params)
    if @timeline.update(mapped_attrs)
      redirect_to video_path(@timeline.video), notice: "タイムラインを更新しました。"
    else
      redirect_to edit_timeline_path(@timeline), alert: "タイムラインの更新に失敗しました。"
    end
  end

  def destroy
    video = @timeline.video
    @timeline.destroy!
    @timelines = video.timelines.order(:start_seconds)

    respond_to do |format|
      format.html { redirect_to video_path(video), notice: "タイムラインを削除しました。" }
      format.turbo_stream
    end
  end

  def show; end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end

  def set_timeline
    @timeline = Timeline.find(params[:id])
  end

  # マイグレーションのカラム名に合わせる
  def timeline_params
    params.require(:timeline).permit(:start_seconds, :end_seconds, :title, :body, :kind, payload: {})
  end

  # フォームの field 名とモデル属性をマッピングするヘルパー
  # 旧フォーム名称（time_seconds / note）も受け取れるようにする
  def map_params_to_model(raw)
    return {} unless raw

    start = raw[:start_seconds].presence || raw[:time_seconds].presence
    # 数値にキャスト（空文字や nil は nil のまま）
    start = start.present? ? start.to_f : nil

    body  = raw[:body].presence || raw[:note].presence
    {
      start_seconds: start,
      end_seconds: raw[:end_seconds].presence ? raw[:end_seconds].to_f : nil,
      title: raw[:title],
      body: body,
      kind: raw[:kind],
      payload: raw[:payload] || {}
    }.compact
  end
end
