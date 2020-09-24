class AddEmailToUsersAndResumeToInterviews < ActiveRecord::Migration[5.1]
  def change
    add_attachment :interviews, :resume
    add_column :users, :email, :string
  end
end
