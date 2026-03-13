require "test_helper"

class InvitationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @host = User.create!(name: "Host User", email: "host@example.com", password: "password", role: "parent")
    @other_user = User.create!(name: "Other User", email: "other@example.com", password: "password", role: "parent")
    @invitee = User.create!(name: "Invitee", email: "invitee@example.com", password: "password", role: "parent")

    @movie = Movie.create!(title: "Inception", description: "Dreams", year: 2010, genre: "Sci-Fi")
    @movie_night = MovieNight.create!(movie: @movie, host: @host, scheduled_at: 1.day.from_now)
  end

  test "host can invite someone" do
    post login_path, params: { email: @host.email, password: "password" }

    assert_difference("Invitation.count", 1) do
      post movie_night_invitations_path(@movie_night), params: { invitation: { user_id: @invitee.id } }
    end
    assert_redirected_to movie_night_path(@movie_night)
  end

  test "other user cannot invite someone" do
    post login_path, params: { email: @other_user.email, password: "password" }

    assert_no_difference("Invitation.count") do
      post movie_night_invitations_path(@movie_night), params: { invitation: { user_id: @invitee.id } }
    end
    assert_redirected_to movie_nights_path
  end
end
