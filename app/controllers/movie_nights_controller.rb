class MovieNightsController < ApplicationController
  before_action :set_movie_night, only: [ :show, :destroy ]

  def index
    @movie_nights = MovieNight.includes(:movie, :host, :invitations).order(scheduled_at: :desc)
  end

  def show
    @invitations = @movie_night.invitations.includes(:user)
    @available_users = User.where.not(id: @movie_night.invitations.select(:user_id))
                           .where.not(id: @movie_night.host_id)
                           .order(:name)
  end

  def new
    @movie_night = MovieNight.new
    @movies = Movie.all.order(:title)
  end

  def create
    @movie_night = MovieNight.new(movie_night_params)
    @movie_night.host = current_user
    if @movie_night.save
      redirect_to @movie_night, notice: "Movie night was successfully created! Now invite some people."
    else
      @movies = Movie.all.order(:title)
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @movie_night.host == current_user || current_user.admin?
      @movie_night.destroy
      redirect_to movie_nights_path, notice: "Movie night was cancelled."
    else
      redirect_to movie_nights_path, alert: "You can only cancel your own movie nights."
    end
  end

  private

  def set_movie_night
    @movie_night = MovieNight.find(params[:id])
  end

  def movie_night_params
    params.require(:movie_night).permit(:movie_id, :scheduled_at, :notes)
  end
end
