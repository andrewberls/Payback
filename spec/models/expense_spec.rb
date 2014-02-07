require 'spec_helper'

describe Expense do
  let(:expense) { Expense.make!(amount: 30.00) }

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

  context '::build' do
    let(:params) do
      {
        commit: "Payback",
        expense: { title: "Test Expense", amount: "2+2" },
        tag_list: "one"
      }
    end

    let(:tag)     { Tag.make!(title: "one") }
    let(:expense) { Expense.build(params) }

    it 'computes the amount' do
      expense.amount.should == 4
    end

    it 'computes the tags' do
      Tag.should_receive(:find_or_create_by_title).with("one").and_return(tag)
      expense.tags.should == [tag]
    end
  end

  context '#cost_for' do
    let(:user1) { User.make! }
    let(:user2) { User.make! }
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

  context '#has_tag?' do
    let(:expense) { Expense.make! }
    let(:one)     { Tag.make!(title: "one") }
    let(:two)     { Tag.make!(title: "two") }

    specify { expense.has_tag?("one") }
    specify { expense.has_tag?("two") }
    specify { !expense.has_tag?("fake") }
  end
end
