class MovieNight < ApplicationRecord
  belongs_to :movie
  belongs_to :host, class_name: "User"
  has_many :invitations, dependent: :destroy
  has_many :invited_users, through: :invitations, source: :user

  validates :scheduled_at, presence: true
end
