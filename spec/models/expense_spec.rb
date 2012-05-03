require 'spec_helper'

describe Expense do
  
  before do
    @seed_group = Group.create(
      title: "Seed Group",
      password: "password",
      password_confirmation: "password"
    )
    @creditor = User.new(
      first_name: "Cory",
      last_name: "Creditor",
      email: "creditor@example.com",
      password: "12345",
      password_confirmation: "12345"
    )
    @debtor = User.new(
      first_name: "Debbie",
      last_name: "Debtor",
      email: "debtor@example.com",
      password: "12345",
      password_confirmation: "12345"
    )
    @expense =  Expense.new(
      title: "Groceries",
      amount: 100.0,
      active: true
    )
    @expense.creditor = @creditor
    @expense.debtor = @debtor
  end

  subject { @expense }

  describe "when title is not present" do
    before { @expense.title = "" }
    it { should_not be_valid }
  end

  describe "when amount is not present" do
    before { @expense.amount = nil }
    it { should_not be_valid }
  end

  describe "when amount is not a number" do
    before { @expense.amount = "" }
    it { should_not be_valid }
  end


end
