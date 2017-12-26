# == Schema Information
#
# Table name: notifications
#
#  id           :integer          not null, primary key
#  notif_type   :string(255)
#  read         :boolean          default(FALSE)
#  expense_id   :integer
#  user_from_id :integer
#  user_to_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :notif_type, :read, :expense_id, :user_from_id, :user_to_id, :created_at, :updated_at
end
