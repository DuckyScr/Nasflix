class MoviesController < ApplicationController
  before_action :require_admin_or_parent, except: [ :index, :show, :conversion_status ]
  before_action :set_movie, only: [ :show, :edit, :update, :destroy ]

  def index
    @movies = Movie.includes(:reviews, :watchlist_entries).with_attached_video.order(created_at: :desc)

    if logged_in? && current_user.child?
      @movies = @movies.where(kid_friendly: true)
    end

    if logged_in?
      @watchlisted_movie_ids = current_user.watchlist_entries.pluck(:movie_id)
      @watch_progresses_by_movie_id = current_user.watch_progresses.where(completed: false, duration: 1..).where("current_time > 0").index_by(&:movie_id)
    else
      @watch_progresses_by_movie_id = {}
      @watchlisted_movie_ids = []
    end
  end

  def show
    if logged_in? && current_user.child? && !@movie.kid_friendly?
      redirect_to root_path, alert: "You don't have permission to watch this."
      return
    end

    @reviews = @movie.reviews.order(created_at: :desc)
    @review = Review.new

    if @movie.series?
      @seasons = @movie.episodes.group_by(&:season_number)

      if params[:episode_id]
        @current_episode = @movie.episodes.find(params[:episode_id])
      elsif @seasons.any?
        first_season = @seasons.keys.min
        @current_episode = @seasons[first_season].min_by(&:episode_number)
      end
    end

    if logged_in?
      @progress = current_user.watch_progresses.find_by(
        movie_id: @movie.id,
        episode_id: @current_episode&.id
      )
    end
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json do
          needs_conversion = @movie.video.attached? && @movie.video.content_type != "video/mp4"
          render json: {
            status: "success",
            redirect_url: movie_path(@movie),
            processing: needs_conversion,
            poll_url: needs_conversion ? conversion_status_movie_path(@movie) : nil
          }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json do
          needs_conversion = @movie.video.attached? && @movie.video.content_type != "video/mp4"
          render json: {
            status: "success",
            redirect_url: movie_path(@movie),
            processing: needs_conversion,
            poll_url: needs_conversion ? conversion_status_movie_path(@movie) : nil
          }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @movie.destroy
    redirect_to movies_url, notice: "Movie was successfully destroyed."
  end

  def conversion_status
    @movie = Movie.find(params[:id])
    status = Rails.cache.read("video_conversion_status_Movie_#{@movie.id}")
    progress = Rails.cache.read("video_conversion_progress_Movie_#{@movie.id}") || 0.0

    if @movie.video.attached? && @movie.video.content_type == "video/mp4"
      render json: { status: "done", progress: 1.0 }
    else
      render json: { status: status || "processing", progress: progress }
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(:title, :description, :genre, :year, :director, :video, :content_type, :kid_friendly)
  end
end
