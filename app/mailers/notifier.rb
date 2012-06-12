class Notifier < ActionMailer::Base

  default :to => 'andrew.berls@gmail.com',
          :from => 'contact@payback.io'

  def new_message(message)
    @message = message # Set an instance variable for the view (text)
    mail(:subject  => "Message from Payback.io",
      :reply_to => message.email)
  end

end
