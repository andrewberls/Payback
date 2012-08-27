require File.expand_path('../../test_helper',  __FILE__)

class ExpenseTest < Test::Unit::TestCase
  context "expense" do
    setup do
      @expense = Expense.first
    end

    context "validations" do
      should "not be valid without a title" do
        @expense.title = ""
        assert !@expense.valid?
      end

      should "not be valid if the amount is not present and numeric" do
        @expense.amount = ""
        assert !@expense.valid?
        @expense.amount = "notvalid"
        assert !@expense.valid?
      end
    end

    should "indicate when has been edited" do
      @expense.update_attributes! :title => "changed"
      assert @expense.edited?
    end

    should "assign to a group of users correctly" do
      creditor = User.find_by_full_name("Admin User")
      attrs    = { title: "Test", amount: 99, action: :payback }
      expense  = Expense.new(attrs) do |e|
        e.group    = Group.first
        e.creditor = creditor
      end

      users = [User.find(2), User.find(3)]
      expense.assign_to(users)

      users.each do |user|
        assert has_debt_to?(user, creditor, expense)
        assert has_credit_to?(creditor, user, expense)
      end
    end

  end
end
