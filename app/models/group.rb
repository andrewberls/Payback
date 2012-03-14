class Group < ActiveRecord::Base

  #------------------------------
  # Validations
  #------------------------------
  attr_accessible :password, :password_confirmation

  has_secure_password

  validates_presence_of :password, :on => :create


  #------------------------------
  # Associations
  #------------------------------
  # Users
  has_and_belongs_to_many :users


  before_create :generate_gid

  def generate_gid
    # A unique external identifier
    # This is used for the 'Join by ID' feature
    # Note that the (external) GID is distinct from the (internal) ID
    self.gid = Digest::MD5.hexdigest(self.id.to_s)[0..4]    
  end

end
