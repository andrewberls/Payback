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
  end

  factory :expense do
    amount   { Faker::Number.number(2) }
    title    { Faker::Commerce.product_name }
    creditor { FactoryGirl.create(:user) }
    debtor   { FactoryGirl.create(:user) }
    group    { FactoryGirl.create(:group) }

    after(:create) do |expense|
      expense.group.add_user(expense.creditor)
      expense.group.add_user(expense.debtor)
    end
  end

  factory :payment do
    creditor = FactoryGirl.create(:user)
    debtor   = FactoryGirl.create(:user)
    exps     = 2.times.map { FactoryGirl.create(:expense, creditor: creditor, debtor: debtor) }

    amount   { exps.map(&:amount).reduce(:+).to_f }
    title    { 'Test Payment' }
    creditor { creditor }
    debtor   { debtor }

    expenses { exps }
  end

  factory :invitation do
    sender { FactoryGirl.create(:user) }
    group  { FactoryGirl.create(:user) }
    recipient_email { Faker::Internet.email }
    used false
  end

  factory :reset_token do
    user { FactoryGirl.create(:user) }
    used false
  end
end
