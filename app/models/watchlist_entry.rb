class WatchlistEntry < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  validates :status, presence: true, inclusion: { in: %w[planning watching completed dropped] }
  validates :movie_id, uniqueness: { scope: :user_id, message: "is already in the watchlist" }

  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after or equal to start date")
    end
  end
end
