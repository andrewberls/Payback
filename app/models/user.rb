class User < ActiveRecord::Base

  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation

  has_secure_password

  validates :first_name, presence: true, 
                   length: {maximum: 50}

  validates :last_name, presence: true, 
                   length: {maximum: 50}

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: {with: valid_email_regex},
                    uniqueness: { case_sensitive: false }

	validates :password, length: { minimum: 5 }

  before_save :generate_auth_token

  private

  def generate_auth_token
      self.auth_token = SecureRandom.urlsafe_base64
  end

end
