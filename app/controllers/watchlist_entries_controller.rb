class WatchlistEntriesController < ApplicationController
  before_action :set_watchlist_entry, only: [ :edit, :update, :destroy ]

  def index
    @watchlist_entries = current_user.watchlist_entries.includes(:movie).order(created_at: :desc)
  end

  def quick_add
    @movie = Movie.find(params[:movie_id])
    existing = WatchlistEntry.find_by(user: current_user, movie: @movie)
    unless existing
      WatchlistEntry.create!(user: current_user, movie: @movie, status: "planning")
    end

    @watchlisted = true
    respond_to do |format|
      format.turbo_stream { render "update_watchlist_buttons" }
      format.html { redirect_back fallback_location: movies_path }
    end
  end

  def quick_remove
    @movie = Movie.find(params[:movie_id])
    entry = WatchlistEntry.find_by(user: current_user, movie: @movie)
    entry&.destroy

    @watchlisted = false
    respond_to do |format|
      format.turbo_stream { render "update_watchlist_buttons" }
      format.html { redirect_back fallback_location: movies_path }
    end
  end


  def new
    @watchlist_entry = current_user.watchlist_entries.build
    @movies = Movie.all.order(:title)
  end

  def create
    @watchlist_entry = current_user.watchlist_entries.build(watchlist_entry_params)
    if @watchlist_entry.save
      redirect_to watchlist_entries_path, notice: "Watchlist entry was successfully created."
    else
      @movies = Movie.all.order(:title)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @movies = Movie.all.order(:title)
  end

  def update
    if @watchlist_entry.update(watchlist_entry_params)
      redirect_to watchlist_entries_path, notice: "Watchlist entry was successfully updated."
    else
      @movies = Movie.all.order(:title)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @watchlist_entry.destroy
    redirect_to watchlist_entries_path, notice: "Watchlist entry was successfully deleted."
  end

  private

  def set_watchlist_entry
    @watchlist_entry = current_user.watchlist_entries.find(params[:id])
  end

  def watchlist_entry_params
    params.require(:watchlist_entry).permit(:movie_id, :start_date, :end_date, :status, :notes)
  end
end
