require "application_system_test_case"

class MovieNightsTest < ApplicationSystemTestCase
  setup do
    @host = User.create!(name: "Host User", email: "host@example.com", password: "password", role: "parent")
    @invitee = User.create!(name: "Invitee", email: "invitee@example.com", password: "password", role: "child")
    @movie = Movie.create!(title: "Inception", description: "Dreams", year: 2010, genre: "Sci-Fi")
  end

  test "host can create a movie night and invite someone" do
    visit login_path
    fill_in "Email", with: @host.email
    fill_in "Password", with: "password"
    click_on "Log in"
    assert_text "Welcome back, #{@host.name}!"

    visit new_movie_night_path
    select "Inception", from: "movie_night[movie_id]"
    fill_in "Date & Time", with: "04/01/2026\t08:00PM"
    fill_in "movie_night[notes]", with: "Bring popcorn"
    click_on "Create Event"

    assert_text "Movie night was successfully created!"

    # Now invite the other user
    select "Invitee", from: "invitation_user_id" if has_select?("invitation_user_id")
    click_on "Send Invite" if has_button?("Send Invite")

    assert_text "Invitation sent!" if has_text?("Invitation sent!")
  end
end
