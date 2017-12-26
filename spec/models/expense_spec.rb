# == Schema Information
#
# Table name: expenses
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creditor_id :integer
#  debtor_id   :integer
#  group_id    :integer
#  amount      :decimal(10, 2)
#  active      :boolean          default(TRUE)
#  action      :string(255)
#

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

  context '.evaluate_amount' do
    it do
      expect(described_class.evaluate_amount('5')).to eql(5.0)
      expect(described_class.evaluate_amount('500')).to eql(500.0)
      expect(described_class.evaluate_amount('5.0')).to eql(5.0)
      expect(described_class.evaluate_amount('5.25')).to eql(5.25)
      expect(described_class.evaluate_amount('5.0 + 2.31')).to eql(7.31)
      expect(described_class.evaluate_amount('5.0+2.31')).to eql(7.31)
      expect(described_class.evaluate_amount('5 + (2*10) - 2')).to eql(23.0)
    end
  end

  context '.build' do
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

  context '#assign_to' do
    let(:creditor) { User.make! }
    let(:debtor1)  { User.make! }
    let(:debtor2)  { User.make! }
    let(:group)    { Group.make! }
    let(:expense)  { FactoryGirl.build(:expense, creditor: creditor) }

    before do
      group.initialize_owner(creditor)
      [debtor1, debtor2].each { |user| group.add_user(user) }
    end

    it 'assigns multiple expenses' do
      expect { expense.assign_to(debtor1, debtor2) }.to change { Expense.count }.by(2)

      # TODO: probably want expense matcher here
      creditor.credits.count.should == 2
      creditor.credits.first.title.should == expense.title

      debtor1.debts.count.should == 1
      debtor1.debts.first.title.should == expense.title

      debtor2.debts.count.should == 1
      debtor2.debts.first.title.should == expense.title
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
