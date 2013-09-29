class InvitationsMailer < ApplicationMailer

  # No @recipient record here - unsubscribe preferences not shown
  def invite(invitation_id)
    @invitation = Invitation.find(invitation_id)
    @group      = @invitation.group
    @sender     = @invitation.sender
    @subject    = "Invitation to join #{@group.title} on Payback.io"

    mail to: @invitation.recipient_email, subject: @subject
  end

end
