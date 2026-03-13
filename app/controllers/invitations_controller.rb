class InvitationsController < ApplicationController
  def create
    @movie_night = MovieNight.find(params[:movie_night_id])
    unless @movie_night.host == current_user || current_user.admin?
      redirect_to movie_nights_path, alert: "You are not authorized to invite people to this movie night."
      return
    end

    @invitation = @movie_night.invitations.build(user_id: params[:invitation][:user_id], status: "pending")

    if @invitation.save
      redirect_to @movie_night, notice: "Invitation sent!"
    else
      redirect_to @movie_night, alert: @invitation.errors.full_messages.join(", ")
    end
  end

  def update
    @invitation = current_user.invitations.find(params[:id])
    if @invitation.update(status: params[:invitation][:status])
      redirect_to movie_night_path(@invitation.movie_night), notice: "Invitation #{@invitation.status}."
    else
      redirect_to movie_night_path(@invitation.movie_night), alert: "Could not update invitation."
    end
  end
end
