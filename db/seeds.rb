ActionMailer::Base.delivery_method = :test

admin_user = User.create!(full_name: "Admin User",  email: "admin@admin.com",  password: "admin",    password_confirmation: "admin")
jeff       = User.create!(full_name: "Jeff Schmoe", email: "jeff@gmail.com",   password: "password", password_confirmation: "password")
david      = User.create!(full_name: "David Dawg",  email: "david@gmail.com",  password: "password", password_confirmation: "password")
nicole     = User.create!(full_name: "Nicole Doe",  email: "nicole@gmail.com", password: "password", password_confirmation: "password")

seed_group = Group.create!(title: "221B Baker Street", gid: 'abcdef') do |group|
  group.initialize_owner(admin_user)
  group.users << [jeff, david, nicole]
end

Tag::CORE_TYPES.each do |type|
  Tag.create!(title: type)
end

# Nicole owes Admin 10 for movie
Expense.new(title: "Movie ticket", amount: 10, active: true, action: :payback) do |exp|
  exp.group    = seed_group
  exp.creditor = admin_user
  exp.assign_to nicole
end

# Jeff owes Admin 45 for groceries
Expense.new(title: "Groceries", amount: 45, active: true, action: :payback) do |exp|
  exp.group    = seed_group
  exp.creditor = admin_user
  exp.tags << Tag.find_by_title("Food")
  exp.assign_to jeff
end

# David owes Admin 50 for chair
Expense.new(title: "IKEA Chair", amount: 50, active: true, action: :payback) do |exp|
  exp.group    = seed_group
  exp.creditor = admin_user
  exp.tags << Tag.find_by_title("Household")
  exp.assign_to david
end

# Nicole owes Admin 65 for beanbag chair
Expense.new(title: "Beanbag chair", amount: 65, active: true, action: :payback) do |exp|
  exp.group    = seed_group
  exp.creditor = admin_user
  exp.assign_to nicole
end

# Admin owes David 85 for textbook
Expense.new(title: "Textbook", amount: 85, active: true, action: :payback) do |exp|
  exp.group    = seed_group
  exp.creditor = david
  exp.assign_to admin_user
end

# Admin owes Nicole 30 for textbook
Expense.new(title: "Shirt", amount: 30, active: true, action: :payback) do |exp|
  exp.group    = seed_group
  exp.creditor = nicole
  exp.assign_to admin_user
end

# Admin owes Jeff 15 for Freebirds
Expense.new(title: "Freebirds", amount: 15, active: true, action: :payback) do |exp|
  exp.group    = seed_group
  exp.creditor = jeff
  exp.tags << Tag.find_by_title("Food")
  exp.assign_to admin_user
end

# Jeff requests Admin mark off groceries
groceries = Expense.find_by_title("Groceries")
Notification.create!(user_from_id: jeff.id, user_to_id: admin_user.id, expense_id: groceries.id, notif_type: 'mark_off')

admin_group = Group.create!(title: "Admin Only", gid: 'defabc') do |group|
  group.initialize_owner(admin_user)
end
