class Invitation < ApplicationRecord
  belongs_to :movie_night
  belongs_to :user

  validates :status, presence: true, inclusion: { in: %w[pending accepted declined] }
  validates :user_id, uniqueness: { scope: :movie_night_id, message: "has already been invited" }

  def pending?
    status == "pending"
  end

  def accepted?
    status == "accepted"
  end

  def declined?
    status == "declined"
  end
end
