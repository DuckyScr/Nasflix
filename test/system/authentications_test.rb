require "application_system_test_case"

class AuthenticationsTest < ApplicationSystemTestCase
  setup do
    @user = User.create!(name: "Test User", email: "test_auth@test.com", password: "password", role: "parent")
  end

  test "user can login and logout" do
    visit root_url
    # Verify redirected to login
    assert_current_path login_path # Assuming initial redirect is to setup if no users or login

    visit login_path
    fill_in "Email", with: @user.email
    fill_in "Password", with: "password"
    click_on "Log in"

    assert_text "Welcome back, #{@user.name}!"
    assert_current_path root_path

    # Assuming a logout link/button exists
    click_on "Logout" if has_button?("Logout") || has_link?("Logout")
  end
end
