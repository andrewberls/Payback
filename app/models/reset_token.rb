require 'tokenable'

class ResetToken < ActiveRecord::Base
  include Tokenable

  LIFESPAN = 4.hours

  attr_accessible :token, :user, :used

  belongs_to :user

  before_create :generate_token
  before_create :set_expires_at

end
