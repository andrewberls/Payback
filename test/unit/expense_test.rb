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

    context "cost per user" do
      setup do
        @user_1  = User.find_by_email("jeff@gmail.com")
        @user_2  = User.find_by_email("david!gmail.com")
        @users   = [@user_1, @user_2]
        @expense = Expense.new(title: "test", amount: 30) do |e|
          e.creditor = User.find_by_email("admin@admin.com")
          e.group    = Group.find_by_title("221B Baker Street")
        end
      end

      should "report the cost per user for split" do
        @expense.action = :split
        assert_equal 10.00, @expense.cost_for(@users)
      end

      should "report the cost per user for payback" do
        @expense.action = :payback
        assert_equal 15.00, @expense.cost_for(@users)
      end

      should "round to nearest 50 cents" do
        @expense.action = :payback

        @expense.amount = 8.79
        assert_equal 9.00, @expense.cost_for( [@users_1] )

        @expense.amount = 8.20
        assert_equal 8.00, @expense.cost_for( [@users_1] )
      end
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
