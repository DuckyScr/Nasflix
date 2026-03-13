class AdminController < ApplicationController
  before_action :require_admin

  def show
    @stats = {
      users: User.count,
      movies: Movie.count,
      reviews: Review.count,
      watchlist_entries: WatchlistEntry.count,
      movie_nights: MovieNight.count,
      invitations: Invitation.count
    }
  end

  def reset
    # Destroy everything
    Invitation.destroy_all
    MovieNight.destroy_all
    WatchlistEntry.destroy_all
    Review.destroy_all
    Movie.destroy_all
    User.destroy_all

    # Purge all Active Storage attachments
    ActiveStorage::Attachment.all.each(&:purge)

    # Clear session
    reset_session

    redirect_to setup_path, notice: "App has been reset. Please create a new admin account."
  end

  def load_demo
    load Rails.root.join("db/seeds.rb")
    redirect_to admin_path, notice: "Demo data loaded successfully!"
  end
end
