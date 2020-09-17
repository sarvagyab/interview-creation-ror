class InterviewMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.interview_mailer.newInterview.subject
  #
  def newInterview(interview)
    @interview = interview
    @interviewee = 

    mail to: "sarvagya60@gmail.com", subject: "please be working"
  end
end
