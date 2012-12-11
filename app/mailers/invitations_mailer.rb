class InvitationsMailer < ActionMailer::Base
  default from: "noreply.paybackio@gmail.com"

  def invite(invitation)
    @invitation = invitation
    @group      = invitation.group
    @sender     = invitation.sender

    mail to: invitation.recipient_email, subject: "Invitation to join #{@group.title} on Payback.io"
  end

end
