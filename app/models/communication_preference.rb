# == Schema Information
#
# Table name: communication_preferences
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  mark_off   :integer          default(1)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  new_debt   :integer          default(1)
#

class CommunicationPreference < ActiveRecord::Base
  attr_accessible :user

  Notification::COMM_TYPES.each do |type|
    attr_accessible type
  end

  belongs_to :user
end
