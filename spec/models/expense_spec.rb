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

  it "registers debts correctly" do
    @user = FactoryGirl.create(:user)
    @user.add_debt(@expense)
    @user.debts.should include @expense
    @expense.debtor.should == @user
  end


  context "it assigns correctly" do
    before do
      @creditor = FactoryGirl.create(:user)
      @expense.creditor = @creditor
    end

    it "assigns to a single user correctly" do
      @user = FactoryGirl.create(:user)
      @expense = FactoryGirl.create(:expense)
      @expense.assign_to @user
      # TODO: can't check if expense is in user.debts because it's getting cloned
      pending "write test"
    end

    it "assigns to a list of users correctly" do
      pending "write test"
    end
  end
  

end