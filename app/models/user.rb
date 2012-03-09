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

  #before_create { generate_token(:auth_token) }

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
