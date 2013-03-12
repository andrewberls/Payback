class ResetToken < ActiveRecord::Base
  attr_accessible :token, :user, :used

  belongs_to :user

  before_create :generate_token
  before_create :set_expires_at

  def expired?
    Time.now > self.expires_at
  end

  def invalid?
    expired? || used
  end

  def mark_used
    update_attributes(used: true)
  end

  private

  def set_expires_at
    self.expires_at ||= 4.hours.from_now
  end

  def generate_token
    begin
      self.token = SecureRandom.urlsafe_base64
    end while self.class.exists?(token: token)
  end

end
