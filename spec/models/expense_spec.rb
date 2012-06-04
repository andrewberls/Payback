require 'spec_helper'

describe Expense do
  
  before do
    @expense = FactoryGirl.build(:expense)
  end

  it "has a valid factory" do
    @expense.should be_valid
  end

  it "is not valid if title is not present" do
    @expense.title = ""
    @expense.should_not be_valid
  end

  it "is not valid if amount is not present" do
    @expense.amount = nil
    @expense.should_not be_valid
  end

  it "is not valid if amount is not a number" do
    @expense.amount = ""
    @expense.should_not be_valid
  end

  it "responds to debtor" do
    @expense.should respond_to(:debtor)
  end

  it "responds to creditor" do
    @expense.should respond_to(:creditor)
  end

  context "it splits correctly" do
    before do
      @group = FactoryGirl.create(:group_with_owner)
      @owner = @group.owner
      @user = FactoryGirl.create(:user)
      @group.add_user(@user)
    end

    it "has an owner" do
      @owner.should be_valid
    end
  end

end