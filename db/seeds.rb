# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin_user = User.create(
  first_name: "Admin",
  last_name: "User",
  email: "admin@admin.com",
  password: "admin",
  password_confirmation: "admin"
)

aux_user_1 = User.create(
  first_name: "Joe",
  last_name: "Schmoe",
  email: "joe@gmail.com",
  password: "password",
  password_confirmation: "password"
)

aux_user_2 = User.create(
  first_name: "Jane",
  last_name: "Doe",
  email: "jane@gmail.com",
  password: "password",
  password_confirmation: "password"
)

seed_group = Group.create(
  title: "Seed Group",
  password: "password",
  password_confirmation: "password"
)

seed_group.initialize_owner admin_user
seed_group.users << aux_user_1
seed_group.users << aux_user_2