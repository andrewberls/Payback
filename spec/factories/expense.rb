FactoryGirl.define do

  factory :expense do
    sequence(:title) { |i| "expense#{i}" }
    amount 150
    active true

    after(:build) do |expense|
      expense.group = FactoryGirl.build(:group)
      expense.creditor = FactoryGirl.build(:user)
      expense.debtor = FactoryGirl.build(:user)
    end
  end

end