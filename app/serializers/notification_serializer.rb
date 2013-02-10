class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :notif_type, :read, :expense_id, :user_from_id, :user_to_id, :created_at, :updated_at
end
