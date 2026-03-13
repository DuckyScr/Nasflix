class ReviewsController < ApplicationController
  def create
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build(review_params)

    if @review.save
      redirect_to @movie, notice: "Review was successfully added."
    else
      @reviews = @movie.reviews.order(created_at: :desc)
      render "movies/show", status: :unprocessable_entity
    end
  end

  private

  def review_params
    params.require(:review).permit(:author, :content, :rating)
  end
end
