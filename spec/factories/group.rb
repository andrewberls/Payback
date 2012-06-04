FactoryGirl.define do

  factory :group do
    title "Test Group"
    password "password"

    factory :group_with_owner do
      after(:build) do |group|
        group.owner = FactoryGirl.build(:user)
      end
    end
    
    factory :group_with_users do
      after(:build) do |group|
        group.owner = FactoryGirl.build(:user)
        3.times { group.users << FactoryGirl.build(:user) }
      end
    end

  end

end