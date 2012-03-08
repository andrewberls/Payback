class User < ActiveRecord::Base

  attr_accessible :email, :password, :password_confirmation

  has_secure_password

  validates_presence_of :email
	validates_presence_of :password, :on => :create
  validates_length_of :password, :in => 6..12  

  before_create { generate_token(:auth_token) }

  def generate_column(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

end
