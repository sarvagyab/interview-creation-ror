class Interview < ApplicationRecord
  has_many :interviewers
  # has_many :users, :through => :interviewers
  has_many :takingInterviews, class_name: 'User', :through => :interviewers, :source => 'user'
  # belongs_to :user, class_name: 'User'
  belongs_to :interviewee, class_name: 'User', :foreign_key => :user_id
end
