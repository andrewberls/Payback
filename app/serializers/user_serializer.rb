# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  auth_token      :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  full_name       :string(255)
#

class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :created_at, :updated_at

  has_many :notifications_from
  has_many :notifications_to
end
