class Group < ActiveRecord::Base

  attr_accessible :password, :password_confirmation

  has_secure_password

  validates_presence_of :password, :on => :create

  before_create :generate_gid

  has_and_belongs_to_many :users

  def generate_gid  
    self.gid = Digest::MD5.hexdigest(self.id.to_s)[0..4]    
  end

end
