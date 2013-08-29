require 'factory_girl'

FactoryGirl.define do
  factory :user do
    full_name { Faker::Name.name }
    email     { Faker::Internet.email }
    password 'password'
    password_confirmation 'password'
  end

  factory :group do
    title { Faker::Address.street_name }
    password 'password'
    password_confirmation 'password'
  end

  factory :expense do
    amount   { Faker::Number.number(2) }
    title    { Faker::Commerce.product_name }
    creditor { FactoryGirl.create(:user) }
    debtor   { FactoryGirl.create(:user) }

    factory :expense_with_group do
      group { FactoryGirl.create(:group) }
    end

    after(:create) do |expense|
      expense.group.add_user(expense.creditor)
      expense.group.add_user(expense.debtor)
    end
  end

  factory :invitation do
    sender { FactoryGirl.create(:user) }
    group  { FactoryGirl.create(:group) }
    recipient_email { Faker::Internet.email }
    used false
  end

  factory :reset_token do
    user { FactoryGirl.create(:user) }
    used false
  end
end
