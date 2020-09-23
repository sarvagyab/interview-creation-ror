class InterviewMailerJob < ApplicationJob
  queue_as :default

  def perform(id)
    interview = Interview.find_by_id(id)
    if(interview)
      puts "Interview still exists so one stage is clear"
      if((interview.start_time - Time.now)<=30.minutes && (interview.start_time-Time.now) >= 27.minutes)
        puts "Sending the mail"
        InterviewMailer.reminderInterview(interview).deliver_later!
      else
        puts "Timings changes not sending the reminder okkk"
      end
    end
  end
end
