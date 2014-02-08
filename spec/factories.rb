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
    expenses do
      2.times.map do
        FactoryGirl.create(:expense, creditor: FactoryGirl.create(:user),
                           debtor: FactoryGirl.create(:user))
      end
    end
    title    { 'Test Payment' }
    amount   { expenses.map(&:amount).reduce(:+).to_f }
    creditor { expenses.first.creditor }
    debtor   { expenses.first.debtor }
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

  factory :tag do
    title { Faker::Commerce.product_name }
  end

  factory :notification do
    user_from  { FactoryGirl.create(:user) }
    user_to    { FactoryGirl.create(:user) }
    read       { false }
    notif_type { Notification::MARKOFF }

    after(:create) do |notif|
      notif.expenses << FactoryGirl.create(:expense,
                                           creditor: notif.user_from, debtor: notif.user_to)
    end
  end
end
