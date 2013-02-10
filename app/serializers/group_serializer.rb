class GroupSerializer < ActiveModel::Serializer
  attributes :gid, :title, :created_at, :updated_at, :owner_id, :users

  has_many :users

  private

  def users
    object.users - [scope]
  end

end
