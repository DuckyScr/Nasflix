class WatchProgress < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  belongs_to :episode, optional: true

  validates :user_id, uniqueness: { scope: [ :movie_id, :episode_id ], message: "progress already exists" }

  def progress_percent
    return 0 if duration.nil? || duration.zero?
    ((current_time / duration) * 100).round
  end

  def time_remaining
    return 0 if duration.nil? || current_time.nil?
    duration - current_time
  end
end
