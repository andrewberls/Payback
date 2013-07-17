class ApplicationMailer < ActionMailer::Base
  default from: "noreply.paybackio@gmail.com"
  helper :utm
end
