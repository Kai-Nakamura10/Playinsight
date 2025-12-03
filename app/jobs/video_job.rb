class VideoJob < ApplicationJob
  queue_as :video

  def perform(video_id)
    video = Video.find_by(id: video_id)
    return unless video&.file&.attached?

    needs_duration  = video.duration_seconds.blank?
    needs_thumbnail = !video.thumbnail.attached?
    return unless needs_duration || needs_thumbnail

    video.file.blob.open(tmpdir: "/tmp") do |src_file|
      movie = FFMPEG::Movie.new(src_file.path)

      if needs_duration
        duration = movie.duration.to_i
        video.update_column(:duration_seconds, duration)
      else
        duration = video.duration_seconds.to_i
      end

      if needs_thumbnail
        Dir.mktmpdir do |dir|
          out = File.join(dir, "thumb.jpg")

          seek = duration >= 5 ? 5 : 0
          movie.screenshot(
            out,
            seek_time: seek,
            resolution: "640x360",
            custom: %w[-nostdin -threads 1]
          )

          File.open(out, "rb") do |f|
            video.thumbnail.attach(
              io: f,
              filename: File.basename(out),
              content_type: "image/jpeg"
            )
          end
        end
      end
    end
  rescue => e
    Rails.logger.error("[VideoJob] video_id=#{video_id} #{e.class}: #{e.message}")
    raise
  end
end
