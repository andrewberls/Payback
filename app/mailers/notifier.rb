class Notifier < ActionMailer::Base

  default to: 'andrew.berls@gmail.com',
          from: 'contact@payback.io'

  def new_message(feedback)
    @feedback = feedback # Set an instance variable for the view (text)
    mail(subject: "Message from Payback.io", reply_to: feedback.email)
  end

end
