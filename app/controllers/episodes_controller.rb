class EpisodesController < ApplicationController
  before_action :set_movie
  before_action :set_episode, only: [ :show, :edit, :update, :destroy, :conversion_status ]
  before_action :require_admin_or_parent, except: [ :show, :conversion_status ]

  def show
    # To display progress or other episode-specific data, if needed
  end

  def new
    @episode = @movie.episodes.build
  end

  def create
    @episode = @movie.episodes.build(episode_params)
    respond_to do |format|
      if @episode.save
        format.html { redirect_to movie_path(@movie), notice: "Episode was successfully added." }
        format.json do
          needs_conversion = @episode.video.attached? && @episode.video.content_type != "video/mp4"
          render json: {
            status: "success",
            redirect_url: movie_path(@movie),
            processing: needs_conversion,
            poll_url: needs_conversion ? conversion_status_movie_episode_path(@movie, @episode) : nil
          }
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @episode.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @episode.update(episode_params)
        format.html { redirect_to movie_path(@movie), notice: "Episode was successfully updated." }
        format.json do
          needs_conversion = @episode.video.attached? && @episode.video.content_type != "video/mp4"
          render json: {
            status: "success",
            redirect_url: movie_path(@movie),
            processing: needs_conversion,
            poll_url: needs_conversion ? conversion_status_movie_episode_path(@movie, @episode) : nil
          }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @episode.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @episode.destroy
    redirect_to movie_path(@movie), notice: "Episode was successfully deleted."
  end

  def conversion_status
    status = Rails.cache.read("video_conversion_status_Episode_#{@episode.id}")
    progress = Rails.cache.read("video_conversion_progress_Episode_#{@episode.id}") || 0.0

    if @episode.video.attached? && @episode.video.content_type == "video/mp4"
      render json: { status: "done", progress: 1.0 }
    else
      render json: { status: status || "processing", progress: progress }
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_episode
    @episode = @movie.episodes.find(params[:id])
  end

  def episode_params
    params.require(:episode).permit(:title, :season_number, :episode_number, :video)
  end
end
