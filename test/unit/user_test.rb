require File.expand_path('../../test_helper',  __FILE__)

class UserTest < Test::Unit::TestCase
  context "group" do
    setup do
      @user = User.first
    end

    context "validations" do
      setup do
        @user = User.new(full_name: "Invalid User", email: "invalid@gmail.com",
          password: "password", password_confirmation: "password")
        assert @user.valid?
      end

      should "not be valid without a full name" do
        @user.full_name = ""
        assert !@user.valid?
      end

      should "not be valid when the full name is too long" do
        @user.full_name = "a" * 51
        assert !@user.valid?
      end

      context "email" do
        should "be required" do
          @user.email = ""
          assert !@user.valid?
        end

        should "be formatted correctly" do
          %w( user@foo,com user_at_foo.org example.user@foo. ).each do |email|
            @user.email = email
            assert !@user.valid?
          end
        end

        should "be unique for each user" do
          @user.email = "admin@admin.com"
          assert !@user.valid?
        end
      end

      should "not be valid without a password" do
        @user.password = ""
        assert !@user.valid?
      end

      should "not be valid when the password doesn't match confirmation" do
        @user.password_confirmation = "mismatch"
        assert !@user.valid?
      end

      should "not be valid when the password is too short" do
        @user.password = "a" * 4
        assert !@user.valid?
      end
    end

    should "generate an auth token before save" do
      @user.save!
      assert @user.auth_token.present?
    end

    should "return a safe list of users from id keys" do
      group        = Group.find_by_title("221B Baker Street")
      current_user = User.find_by_email("admin@admin.com")
      user_params  = { '2'=>'on', '3'=>'on' }

      jeff         = User.find_by_email("jeff@gmail.com")
      david        = User.find_by_email("david@gmail.com")
      not_in_group = User.find_by_email("blank_one@email.com")

      assert_equal [jeff, david], User.users_from_keys(user_params, group, current_user)

      user_params.merge({ '5'=>'on' }) # not_in_group" id 5
      assert_equal [jeff, david], User.users_from_keys(user_params, group, current_user)
    end

  end
end
