FactoryGirl.define do

  factory :user do
    sequence(:full_name) { |i| "John#{i} Doe" }
    sequence(:email) { |i| "user#{i}@email.com" }
    password "password"

    factory :user_with_expenses do
      after(:build) do |user|
        creditor = FactoryGirl.build(:user)
        debtor = FactoryGirl.build(:user)
        user.posts << FactoryGirl.build(:expense, creditor: creditor, debtor: debtor)
      end
    end

    factory :admin_user do
      sequence(:full_name) { |i| "Admin User #{i}" }
    end

  end
end