class User < ApplicationRecord
    has_many :interviewers
    # has_many :interviews, :through => :interviewers
    has_many :takingInterviews,class_name: 'Interview', :through => :interviewers, :source => 'interview'
    has_many :givingInterviews, class_name: 'Interview', foreign_key: :user_id
end
