require File.expand_path('../../test_helper',  __FILE__)


# require 'spec_helper'

# describe Group do

#   before do
#     @group = FactoryGirl.create(:group)
#   end

#   it "has a valid factory" do
#     @group.should be_valid
#   end

#   it "is not valid without a title" do
#     @group.title = ""
#     @group.should_not be_valid
#   end

#   it "is not valid if the title is too long" do
#     @group.title= "a" * 51
#     @group.should_not be_valid
#   end

#   it "is not valid if the password is not present" do
#     group = FactoryGirl.build(:group, password: "")
#     group.should_not be_valid
#   end

#   it "is not valid when when password doesn't match confirmation" do
#     @group.password_confirmation = "mismatch"
#     @group.should_not be_valid
#   end

#   it "is not valid with a password that's too short" do
#     @group.password = @group.password_confirmation = "a" * 4
#     @group.should_not be_valid
#   end


#   context "gid" do
#     it "has a gid present before save" do
#       @group[:gid].should_not be_blank
#     end

#     it "has a gid of length 6" do
#       @group[:gid].length.should == 6
#     end
#   end


#   context "initialize owner" do
#     before do
#       @user = FactoryGirl.create(:user)
#       @group.initialize_owner(@user)
#     end

#     it "assigns ownership correctly" do
#       @group.owner.should == @user
#       @user.owned.should include @group
#     end

#     it "assigns user membership correctly" do
#       @user.owned.should include @group
#       @user.groups.should include @group
#       @user.groups.count.should == 1
#     end
#   end


#   context "add user" do
#     before do
#       @user = FactoryGirl.create(:user, full_name: "Bob Smith")
#       @group.add_user(@user)
#     end

#     it "adds the user to the group" do
#       @group.users.should include @user
#     end

#     it "adds itself to the users list of groups" do
#       @user.groups.should include @group
#       @user.groups.count.should == 1
#     end
#   end


#   context "remove user" do
#     before do
#       @user = FactoryGirl.create(:user)
#       @group.add_user(@user)

#       # TODO: This is horrible, fix it
#       @expense = FactoryGirl.create(:expense)
#       @expense.creditor = @user
#       @expense.group = @group
#       @expense.assign_to FactoryGirl.create(:user)
#     end

#     it "removes the user from the group" do
#       @group.remove_user(@user)
#       @group.users.should_not include @user
#     end

#     it "removes itself from the users groups" do
#       @group.remove_user(@user)
#       @user.groups.should_not include @group
#     end

#     it "removes the users expenses" do
#       @group.expenses.should_not be_blank
#       puts "Expenses before: " + @group.expenses.collect { |e| e.creditor.full_name }.inspect
#       @group.remove_user(@user)
#       puts "Expenses after: " + @group.expenses.collect { |e| e.creditor.full_name }.inspect
#       @group.expenses.should be_blank
#     end
#   end

# end
