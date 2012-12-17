class Invitation < ActiveRecord::Base

  attr_accessible :group, :sender, :recipient_email, :used

  belongs_to :group
  belongs_to :sender, class_name: 'User'

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :recipient_email,
    presence: true,
    format: { with: valid_email_regex }

  validates :group, presence: true
  validates :sender, presence: true

  before_create :generate_token

  after_save :send_invitation_email

  private

  def generate_token
    digest_string = Time.now.to_i.to_s
    self.token    = Digest::MD5.hexdigest(digest_string)[0..14]
  end

  def send_invitation_email
    InvitationsMailer.invite(self).deliver if Rails.env == 'production'
  end

end
