require 'tokenable'

class Invitation < ActiveRecord::Base
  include Tokenable

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

  after_create :send_invitation_email

  private

  def send_invitation_email
    InvitationsMailer.delay.invite(self.id)
  end

end
