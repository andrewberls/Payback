require File.expand_path('../../test_helper',  __FILE__)

class GroupTest < Test::Unit::TestCase
  context "group" do
    context "validations" do
      setup do
        @group = Group.new(title: "Invalid Group", password: "password",
          password_confirmation: "password")
      end

      should "not be valid without a title" do
        @group.title = ""
        assert !@group.valid?
      end

      should "not be valid when the title is too long" do
        @group.title = "a" * 51
        assert !@group.valid?
      end

      should "not be valid when the password is not present" do
        @group.password = ""
        assert !@group.valid?
      end

      should "not be valid when the password doesn't match confirmation" do
        @group.password_confirmation = "mismatch"
        assert !@group.valid?
      end

      should "not be valid when the password is too short" do
        @group.password = @group.password_confirmation = "a" * 4
        assert !@group.valid?
      end
    end

    context "gid" do
      setup do
        @group = Group.first
      end

      should "be generated before save" do
        assert @group.gid.present?
      end

      should "be six characters long" do
        assert @group.gid.length == 6
      end
    end

    should "set ownership" do
      group = Group.find_by_title("Blank Group")
      owner = User.find_by_email("blank_one@email.com")
      user  = User.find_by_email("blank_two@email.com")

      group.initialize_owner(owner)
      group.save!

      assert group.owner == owner
      assert owner.owned  == [ group ]
      assert owner.groups == [ group ]
    end

    context "users" do
      should "add users" do

      end

      should "remove users and their expenses" do

      end
    end

    context "expenses" do
      should "report aggregate expenses from all users" do

      end

      should "report all credits from a specific user" do

      end

      should "report all debts from a specific user" do

      end
    end

  end
end
