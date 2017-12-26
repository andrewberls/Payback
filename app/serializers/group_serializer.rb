# == Schema Information
#
# Table name: groups
#
#  id              :integer          not null, primary key
#  gid             :string(255)
#  title           :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  owner_id        :integer
#

class GroupSerializer < ActiveModel::Serializer
  attributes :gid, :title, :created_at, :updated_at, :owner_id, :users

  has_many :users

  private

  def users
    object.users - [scope]
  end

end
