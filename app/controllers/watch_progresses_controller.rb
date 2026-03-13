class WatchProgressesController < ApplicationController
  def update_progress
    movie_id = params[:movie_id]
    episode_id = params[:episode_id]
    current_time = params[:current_time].to_f
    duration = params[:duration].to_f

    return head :bad_request unless movie_id.present?

    progress = current_user.watch_progresses.find_or_initialize_by(
      movie_id: movie_id,
      episode_id: episode_id
    )

    progress.current_time = current_time
    progress.duration = duration

    # Consider it completed if within 5% of the end
    progress.completed = true if duration > 0 && (current_time / duration) > 0.95

    if progress.save
      # If completed, update watchlist only if the entry already exists
      if progress.completed?
        entry = WatchlistEntry.find_by(user: current_user, movie_id: movie_id)
        if entry && entry.status != "completed"
          entry.update(status: "completed", end_date: Date.today)
        end
      end

      render json: { status: "ok" }
    else
      render json: { status: "error", errors: progress.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
