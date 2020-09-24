# Preview all emails at http://localhost:3000/rails/mailers/interview_mailer
class InterviewMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/interview_mailer/newInterview
  def newInterview
    InterviewMailer.newInterview(Interview.last)
  end

end
