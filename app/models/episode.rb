class Episode < ApplicationRecord
  belongs_to :movie
  has_one_attached :video
  has_one_attached :thumbnail
  has_many :watch_progresses, dependent: :destroy

  validates :title, presence: true
  validates :episode_number, presence: true, numericality: { greater_than: 0 }
  validates :season_number, presence: true, numericality: { greater_than: 0 }
  validates :episode_number, uniqueness: { scope: [ :movie_id, :season_number ], message: "already exists in this season" }

  validate :acceptable_video

  after_commit :queue_video_processing, on: [ :create, :update ]

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
