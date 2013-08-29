require 'spec_helper'

describe Expense do
  let(:expense) { FactoryGirl.create(:expense_with_group, amount: 30.00) }

  context 'validations' do
    it "is not valid without a title" do
      expense.title = ''
      expense.should_not be_valid
    end

    it "is not valid if the amount is not present and numeric" do
      expense.amount = ''
      expense.should_not be_valid
    end

    it 'is not valid when the amount is not numeric' do
      expense.amount = 'notvalid'
      expense.should_not be_valid
    end
  end

  it 'indicates when has been edited' do
    expense.should_not be_edited
    expense.update_attributes! title: 'changed'
    expense.should be_edited
  end

  context 'cost per user' do
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    let(:users) { [user1, user2] }

    it 'report the cost per user for split' do
      expense.action = :split
      expense.cost_for(users).should == 10.00
    end

    it 'report the cost per user for payback' do
      expense.action = :payback
      expense.cost_for(users).should == 15.00
    end

    it 'rounds to nearest 50 cents' do
      expense.action = :payback
      expense.amount = 8.79
      expense.cost_for([user1]).should == 9.00

      expense.amount = 8.20
      expense.cost_for([user1]).should == 8.00
    end
  end
end
