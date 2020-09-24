class Interview < ApplicationRecord

  has_attached_file :resume
  validates_attachment :resume, content_type: {content_type:"application/pdf"}
  validates_attachment_size :resume, less_than: 2.megabytes
  validates_attachment_file_name :resume, matches: [/pdf\z/]
  do_not_validate_attachment_file_type :resume



  has_many :interviewers
  # has_many :users, :through => :interviewers
  has_many :takingInterviews, class_name: 'User', :through => :interviewers, :source => 'user', :dependent => :destroy
  # belongs_to :user, class_name: 'User'
  belongs_to :interviewee, class_name: 'User', :foreign_key => :user_id

  validates :name, :user_id, presence: true

end
