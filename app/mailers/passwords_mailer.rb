class PasswordsMailer < ApplicationMailer

  def reset(token)
    @token      = token
    @recipient  = token.user
    @hide_unsub = true
    @subject    = "Reset Password on payback.io"

    mail to: @recipient.email, subject: @subject
  end
end
