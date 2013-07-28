admin_user = User.create!(full_name: "Admin User",  email: "admin@admin.com",  password: "admin",    password_confirmation: "admin")
jeff       = User.create!(full_name: "Jeff Schmoe", email: "jeff@gmail.com",   password: "password", password_confirmation: "password")
david      = User.create!(full_name: "David Dawg",  email: "david@gmail.com",  password: "password", password_confirmation: "password")
nicole     = User.create!(full_name: "Nicole Doe",  email: "nicole@gmail.com", password: "password", password_confirmation: "password")

seed_group = Group.create!(title: "221B Baker Street", password: "password", password_confirmation: "password", gid: 'abcdef') do |group|
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

# Jeff requests Admin mark off groceries
groceries = Expense.find_by_title("Groceries")
Notification.create!(user_from_id: jeff.id, user_to_id: admin_user.id, expense_id: groceries.id, notif_type: 'mark_off')

# TEST DATA
# Users/groups with no associations
blank_user_1 = User.create!(full_name: "Blank One", email: "blank_one@email.com", password: "password", password_confirmation: "password")
blank_user_2 = User.create!(full_name: "Blank Two", email: "blank_two@email.com", password: "password", password_confirmation: "password")
blank_group  = Group.create!(title: "Blank Group", password: "blank_password", password_confirmation: "blank_password", gid: 'abc123')

# Single-member group
admin_group = Group.create!(title: "Admin Only", password: "password", password_confirmation: "password", gid: 'defabc') do |group|
  group.initialize_owner(admin_user)
end
