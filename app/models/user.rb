class User < ApplicationRecord
  has_secure_password

  has_many :hosted_movie_nights, class_name: "MovieNight", foreign_key: :host_id, dependent: :destroy
  has_many :invitations, dependent: :destroy
  has_many :watch_progresses, dependent: :destroy
  has_many :watchlist_entries, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email" }
  validates :role, presence: true, inclusion: { in: %w[admin parent child] }

  def admin?
    role == "admin"
  end

  def parent?
    role == "parent"
  end

  def child?
    role == "child"
  end
end
