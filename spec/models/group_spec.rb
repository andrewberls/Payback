require 'spec_helper'
require 'group'

describe Group do
  
  before do
    @group = Group.new(
      title: "Example Title",
      password: "12345",
      password_confirmation: "12345"
    )
    @user = User.new(
      first_name: "John",
      last_name: "Smith",
      email: "user@example.com",
      password: "12345",
      password_confirmation: "12345"
    )
  end

  subject { @group }
  
  it { should respond_to(:title) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  describe "when title is not present" do
    before { @group.title = "" }
    it { should_not be_valid }
  end

  describe "when title is too long" do
    before { @group.title= "a" * 51 }
    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @group.password = @group.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @group.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "with a password that's too short" do
    before { @group.password = @group.password_confirmation = "a" * 4 }
    it { should be_invalid }
  end

  describe "gid present before save" do
    before do
      @group.generate_gid
      @group.save
    end
    its(:gid) { should_not be_blank }
  end

  describe "initialize_owner" do
    before do
      current_user = @user
      @group.initialize_owner(current_user)
    end
    #its(:owner) { should_equal @user }
  end

end
