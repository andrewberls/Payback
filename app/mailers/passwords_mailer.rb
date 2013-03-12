class PasswordsMailer < ActionMailer::Base
  default from: "noreply.paybackio@gmail.com"

  def reset(token)
    @token = token
    @user  = token.user
    mail to: @user.email, subject: "Reset Password on payback.io"
  end
end
