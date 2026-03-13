require "application_system_test_case"

class WatchlistsTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(name: "Test User", email: "test_watchlist@test.com", password: "password", role: "parent")
    @movie = Movie.create!(title: "The Matrix", description: "Neo", year: 1999, genre: "Sci-Fi")
  end

  test "user can add and remove movie from watchlist" do
    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    click_on "Log in"
    assert_text "Welcome back, #{@user.name}!"

    visit movie_path(@movie)

    # We click the add to watchlist button
    find('button[title="Add to list"]').click
    assert_selector 'button[title="Remove from list"]' # Wait for turbo update

    visit watchlist_entries_path
    assert_text "The Matrix"
  end
end
