require 'spec_helper'

describe Group do
  
  before do
    @group = FactoryGirl.create(:group)
  end

  it "should have a valid factory" do
    @group.should be_valid
  end
  
  it "should not be valid without a title" do
    @group.title = ""
    @group.should_not be_valid
  end

  it "should not be valid if the title is too long" do
    @group.title= "a" * 51
    @group.should_not be_valid
  end

  it "should not be valid if the password is not present" do
    group = FactoryGirl.build(:group, password: "")
    group.should_not be_valid
  end

  it "should not be valid when when password doesn't match confirmation" do
    @group.password_confirmation = "mismatch"
    @group.should_not be_valid
  end

  it "should not be valid with a password that's too short" do
    @group.password = @group.password_confirmation = "a" * 4
    @group.should_not be_valid
  end

  context "gid" do
    it "should have a gid present before save" do
      @group[:gid].should_not be_blank
    end

    it "should have a gid of length 6" do
      @group[:gid].length.should == 6
    end
  end

  context "initialize owner" do
    before do
      @user = FactoryGirl.create(:user)
      @group.initialize_owner(@user)
    end

    it "should assign ownership correctly" do
      @group.owner.should == @user
      @user.owned.should include @group
    end

    it "should assign user membership correctly" do
      @user.owned.should include @group
      @user.groups.should include @group
      @user.groups.count.should == 1
    end
  end

  context "add user" do
    before do
      @user = FactoryGirl.create(:user, first_name: "Bob")
      @group.add_user(@user)
    end

    it "should add the user to the group" do
      @group.users.should include @user
    end

    it "should add itself to the users list of groups" do
      @user.groups.should include @group
      @user.groups.count.should == 1
    end
  end
  
end
