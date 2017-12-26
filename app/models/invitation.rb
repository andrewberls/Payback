# == Schema Information
#
# Table name: invitations
#
#  id              :integer          not null, primary key
#  token           :string(255)
#  sender_id       :integer
#  group_id        :integer
#  recipient_email :string(255)
#  used            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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
