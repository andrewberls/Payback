require File.expand_path('../test_helper',  __FILE__)

class ExpenseTest < Test::Unit::TestCase
  context "test helper" do
    setup do
      @debtor   = User.find_by_full_name("Nicole Doe")
      @creditor = User.find_by_full_name("Admin User")
      @other    = User.find_by_full_name("David Dawg")
      @expense  = Expense.find_by_title("Beanbag chair")
    end

    should "indicate when a user has a debt to another user" do
      assert has_debt_to?(@debtor, @creditor, @expense)
    end

    should "indicate when a user has a credit to another user" do
      assert has_credit_to?(@creditor, @debtor, @expense)
    end

    should "return false for non matches" do
      assert !has_debt_to?(@debtor, @other, @expense)
      assert !has_credit_to?(@creditor, @other, @expense)
    end
  end
end
