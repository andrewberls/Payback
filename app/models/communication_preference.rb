class CommunicationPreference < ActiveRecord::Base
  attr_accessible :user

  Notification::VALID_TYPES.each do |type|
    attr_accessible type
  end

  belongs_to :user
end
