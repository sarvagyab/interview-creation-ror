class CreateInterviewers < ActiveRecord::Migration[5.1]
  def change
    create_table :interviewers do |t|
      t.references :interview, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
