require 'test_helper'

class SignupUsersTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.new(username: "john", email: "john@example.com", password: "password")
  end

  test "get new user form and create user" do
    get signup_path
    assert_template 'users/new'
    assert_difference 'User.count', 1 do
      sign_up_as(@user, "password")
      post_via_redirect users_path, user:{ username:"john", email:"john@example.com", password: "password" }
    end
    sign_in_as(@user, "password")
    get users_path(@user)
    assert_match "john", response.body
  end
  
  test "invalid user submission results in failure" do
    get signup_path
    assert_template 'users/new'
    assert_no_difference 'User.count' do
      post users_path, user:{ username:" ", email:" ", password: " " }
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
    assert_select 'div.panel-body'
  end
  
end