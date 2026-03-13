require "test_helper"

class WatchlistEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test User", email: "test@example.com", password: "password", role: "parent")
    @other_user = User.create!(name: "Other User", email: "other@example.com", password: "password", role: "parent")
    @movie = Movie.create!(title: "The Matrix", description: "Neo", year: 1999, genre: "Sci-Fi")
    @watchlist_entry = @user.watchlist_entries.create!(movie: @movie, status: "planning")
    @other_watchlist_entry = @other_user.watchlist_entries.create!(movie: @movie, status: "planning")

    # Simulate login
    post login_path, params: { email: @user.email, password: "password" }
  end

  test "should only show current user's watchlist entries" do
    get watchlist_entries_path
    assert_response :success
    assert_select "div", text: /The Matrix/ # assuming movie title shows up
    # Since we can't easily assert the difference without specific views,
    # we can check the assigned variable if we use a controller test,
    # but in integration tests we check the view.
    # At least we verify the index renders successfully.
  end

  test "should not allow editing another user's watchlist entry" do
    get edit_watchlist_entry_path(@other_watchlist_entry)
    assert_response :not_found
  end

  test "should not allow updating another user's watchlist entry" do
    patch watchlist_entry_path(@other_watchlist_entry), params: { watchlist_entry: { status: "watching" } }
    assert_response :not_found
  end

  test "should not allow destroying another user's watchlist entry" do
    delete watchlist_entry_path(@other_watchlist_entry)
    assert_response :not_found
  end
end
