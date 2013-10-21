class CommunicationPreference < ActiveRecord::Base
  attr_accessible :user

  Notification::COMM_TYPES.each do |type|
    attr_accessible type
  end

  belongs_to :user
end
