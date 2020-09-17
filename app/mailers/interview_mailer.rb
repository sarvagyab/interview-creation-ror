class InterviewMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.interview_mailer.newInterview.subject
  #
  # def newInterview(interview,interviewee,interviewers)
  def newInterview(interview)
    @interview = interview
    @interviewee = interview.interviewee
    @interviewers = interview.takingInterviews
    puts "this is the email we've been waiting for"
    puts @interviewee.email

    mail to: @interviewee.email, subject: "Your interview is scheduled with Interview Creators is Scheduled"
  end


  def reminderInterview(interview)
    @interview = interview
    @interviewee = interview.interviewee
    @interviewers = interview.takingInterviews

    mail to: @interviewee.email, subject: "REMINDER - Your interview is scheduled with Interview Creators is Scheduled"
  end

  def editInterview(interview)
    @interview = interview
    @interviewee = interview.interviewee
    @interviewers = interview.takingInterviews

    puts "this is the email we've been waiting for"
    puts @interviewee.email

    mail to: @interviewee.email, subject: "RESCHEDULE - Your interview has been rescheduled"
  end


end
