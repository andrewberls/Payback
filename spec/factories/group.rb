FactoryGirl.define do

  factory :group do
    title "Test Group"
    password "password"

    factory :group_with_owner do
      after(:build) do |group|
        group.initialize_owner FactoryGirl.build(:user)
      end
    end
    
    factory :group_with_users do
      after(:build) do |group|
        group.owner = FactoryGirl.build(:user)
        group.users << FactoryGirl.build(:user)
      end
    end

  end

end