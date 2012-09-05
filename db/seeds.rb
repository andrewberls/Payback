# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin_user = User.create!(
  full_name: "Admin User",
  email: "admin@admin.com",
  password: "admin",
  password_confirmation: "admin"
)

aux_user_1 = User.create!(
  full_name: "Jeff Schmoe",
  email: "jeff@gmail.com",
  password: "password",
  password_confirmation: "password"
)

aux_user_1b = User.create!(
  full_name: "David Dawg",
  email: "david@gmail.com",
  password: "password",
  password_confirmation: "password"
)

aux_user_2 = User.create!(
  full_name: "Nicole Doe",
  email: "nicole@gmail.com",
  password: "password",
  password_confirmation: "password"
)

seed_group = Group.create!(
  title: "221B Baker Street",
  password: "password",
  password_confirmation: "password",
  gid: 'abcdef'
)

seed_group.initialize_owner admin_user
seed_group.users << aux_user_1
seed_group.users << aux_user_1b
seed_group.users << aux_user_2

# nicole owes 65 for beanbag
# jeff owes 45 for groceries
# nicole owes 10 for movie
# owe 500 to david for rent

movies = Expense.create!(
  title: "Movie ticket",
  amount: 10,
  active: 1
)
movies.group = seed_group
movies.creditor = admin_user
movies.assign_to aux_user_2


groceries = Expense.create!(
  title: "Groceries",
  amount: 45,
  active: 1
)
groceries.group = seed_group
groceries.creditor = admin_user
groceries.assign_to aux_user_1


beanbag = Expense.create!(
  title: "Beanbag chair",
  amount: 65,
  active: 1
)
beanbag.group = seed_group
beanbag.creditor = admin_user
beanbag.assign_to aux_user_2


rent = Expense.create!(
  title: "Textbook",
  amount: 85,
  active: 1
)
rent.group = seed_group
rent.creditor = aux_user_1b
rent.assign_to admin_user





blank_user_1 = User.create!(
  full_name: "Blank One",
  email: "blank_one@email.com",
  password: "password",
  password_confirmation: "password"
)

blank_user_2 = User.create!(
  full_name: "Blank Two",
  email: "blank_two@email.com",
  password: "password",
  password_confirmation: "password"
)

blank_group = Group.create!(
  title: "Blank Group",
  password: "blank_password",
  password_confirmation: "blank_password",
  gid: 'abc123'
)
