# == Schema Information
#
# Table name: reset_tokens
#
#  id         :integer          not null, primary key
#  token      :string(255)
#  user_id    :integer
#  expires_at :datetime
#  used       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'tokenable'

class ResetToken < ActiveRecord::Base
  include Tokenable

  LIFESPAN = 4.hours

  attr_accessible :token, :user, :used

  belongs_to :user

  before_create :generate_token
  before_create :set_expires_at

end
