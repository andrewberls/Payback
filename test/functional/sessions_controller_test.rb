# post :create, :post => { :title => 'Some title'}
# assert_redirected_to post_path(assigns(:post))
#
# assigns(:name), flash, session, cookies
# @request, @response



require File.expand_path('../../test_helper',  __FILE__)

def log_in_user(user_or_email, pass='')
  case user_or_email
  when ActiveRecord::Base
    user = user_or_email
    @request.cookies[:auth_token] = user.auth_token
  when String
    email = user_or_email
    post :create, email: email, password: pass
  end
end

class SessionsControllerTest < ActionController::TestCase
  context "login" do
    setup do
      cookies.delete(:auth_token)
    end

    should "be availble to all users" do
      get :new
      assert_response 200
    end


    should "fail if any fields are blank" do
      post :create, email: 'admin@admin.com'
      assert_template :new
      assert_equal "Invalid email or password", flash[:error]

      post :create, password: 'admin'
      assert_template :new
      assert_equal "Invalid email or password", flash[:error]
    end

    should "fail if credentials are incorrect" do
      post :create, email: 'admin@admin.com', password: 'wrongpass'
      assert_template :new
      assert_equal "Invalid email or password", flash[:error]
    end


    should "log in user if credentials are correct" do
      post :create, email: 'admin@admin.com', password: 'admin'
      assert_redirected_to expenses_path
    end

    should "redirect signed in users" do
      user = User.find_by_email!('admin@admin.com')
      log_in_user(user)
      assert_equal user.auth_token, cookies[:auth_token]
      get :new
      assert_redirected_to expenses_path
    end


    context "logout" do
      setup do
        @user = User.find_by_email!('admin@admin.com')
        log_in_user(@user)
      end

      should "log out signed in users" do
        assert_equal @user.auth_token, cookies[:auth_token]
        get :destroy
        assert_nil cookies[:auth_token]
        assert_redirected_to root_url
      end

      should "do nothing for signed out users" do
        cookies.delete(:auth_token)
        get :destroy
        assert_redirected_to root_url
      end
    end


    # context "reset password" do
    #   should "test" do
    #
    #   end
    # end

  end
end
