class Group < ActiveRecord::Base

  #------------------------------
  # Validations
  #------------------------------
  attr_accessible :title, :password, :password_confirmation

  has_secure_password

  validates :title, 
    presence: true,
    length: {maximum: 50}

  validates :password,
    presence: true,
    length: { minimum: 5 }


  #------------------------------
  # Associations
  #------------------------------
  # Users
  has_and_belongs_to_many :users
  has_one :owner, :class_name => "User"


  before_create [:generate_gid, :initialize_owner]

  def generate_gid
    # A unique external identifier
    # This is used for the 'Join by ID' feature
    # Note that the (external) GID is distinct from the (internal) ID
    digest_string = self.id.to_s << Time.now.to_i.to_s # Combine auto id + timestamp for uniqueness
    self.gid = Digest::MD5.hexdigest(digest_string)[0..5]
  end

  def initialize_owner(user)
    set_owner user
    self.users << user
  end

  def set_owner(user)
    self.owner = user
  end

end
