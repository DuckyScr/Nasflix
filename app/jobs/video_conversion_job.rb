class VideoConversionJob < ApplicationJob
  queue_as :default

  def perform(record_class, record_id)
    record = record_class.constantize.find_by(id: record_id)
    return unless record && record.video.attached?

    needs_conversion = record.video.content_type != "video/mp4"
    needs_thumbnail = !record.thumbnail.attached?

    return unless needs_conversion || needs_thumbnail

    attachment = record.video

    # Download original file temporarily
    original_file = Tempfile.new([ "original", File.extname(attachment.filename.to_s) ], binmode: true)
    begin
      original_file.write(attachment.download)
      original_file.rewind

      # Initialize FFMPEG
      movie = FFMPEG::Movie.new(original_file.path)

      # 1. Extract Thumbnail if needed
      if needs_thumbnail
        thumb_file = Tempfile.new([ "thumb", ".jpg" ], binmode: true)
        # Try to grab a frame at 5s, or 10% in if video is very short
        target_time = movie.duration ? [ 5, movie.duration * 0.1 ].min : 5
        target_time = [ target_time, 0 ].max

        begin
          movie.screenshot(thumb_file.path, seek_time: target_time, resolution: "1280x720", preserve_aspect_ratio: :width)
          record.thumbnail.attach(
            io: File.open(thumb_file.path),
            filename: "thumbnail.jpg",
            content_type: "image/jpeg"
          )
        rescue => e
          Rails.logger.error("Failed to extract thumbnail: #{e.message}")
        ensure
          thumb_file.close
          thumb_file.unlink
        end
      end

      # 2. Convert Video if needed
      if needs_conversion
        output_filename = "#{attachment.filename.base}.mp4"
        output_file = Tempfile.new([ "converted", ".mp4" ], binmode: true)

        progress_key = "video_conversion_progress_#{record_class}_#{record_id}"
        status_key = "video_conversion_status_#{record_class}_#{record_id}"
        Rails.cache.write(status_key, "processing")
        Rails.cache.write(progress_key, 0.0)

        # Transcode to standard h264 MP4 to ensure 100% browser compatibility
        options = %w[-c:v libx264 -preset fast -crf 23 -c:a aac -b:a 128k -movflags +faststart]

        last_progress = 0.0
        movie.transcode(output_file.path, options) do |progress|
          if (progress - last_progress) > 0.01
            Rails.cache.write(progress_key, progress)
            last_progress = progress
          end
        end

        # Attach the new MP4 in place of the old file
        ActiveRecord::Base.transaction do
          record.video.attach(
            io: File.open(output_file.path),
            filename: output_filename,
            content_type: "video/mp4"
          )
        end

        Rails.cache.write(progress_key, 1.0)
        Rails.cache.write(status_key, "done")
      end

    ensure
      original_file.close
      original_file.unlink
      if defined?(output_file) && output_file
        output_file.close
        output_file.unlink
      end
    end
  end
end
