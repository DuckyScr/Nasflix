class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :watchlist_entries, dependent: :destroy
  has_many :movie_nights, dependent: :destroy
  has_many :episodes, dependent: :destroy
  has_many :watch_progresses, dependent: :destroy
  has_one_attached :video
  has_one_attached :thumbnail

  validates :title, presence: true
  validates :genre, presence: true
  validates :content_type, inclusion: { in: %w[movie series], allow_nil: true }

  validate :acceptable_video

  after_commit :queue_video_processing, on: [ :create, :update ]

  def series?
    content_type == "series"
  end

  def movie?
    content_type != "series"
  end

  private

  def acceptable_video
    return unless video.attached?

    unless video.content_type.in?(%w[video/mp4 video/x-msvideo video/webm video/x-matroska video/mkv application/x-matroska video/quicktime])
      errors.add(:video, "must be an MP4, AVI, WebM, MKV, or MOV file")
    end

    if video.byte_size > 2.gigabytes
      errors.add(:video, "must be less than 2GB")
    end
  end

  def queue_video_processing
    return unless video.attached?

    needs_conversion = video.content_type != "video/mp4"
    needs_thumbnail = !thumbnail.attached?

    if (needs_conversion || needs_thumbnail) && previous_changes.key?("updated_at")
      VideoConversionJob.perform_later(self.class.name, id)
    end
  end
end
