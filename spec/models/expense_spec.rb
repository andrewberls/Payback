require 'spec_helper'

describe Expense do
  
  before do
    @expense = FactoryGirl.build(:expense)
  end

  it "has a valid factory" do
    @expense.should be_valid
  end

  it "should not be valid if title is not present" do
    @expense.title = ""
    @expense.should_not be_valid
  end

  it "should not be valid if amount is not present" do
    @expense.amount = nil
    @expense.should_not be_valid
  end

  it "should not be valid if amount is not a number" do
    @expense.amount = ""
    @expense.should_not be_valid
  end

  it "should respond to debtor" do
    @expense.should respond_to(:debtor)
  end

  it "should respond to creditor" do
    @expense.should respond_to(:creditor)
  end

end