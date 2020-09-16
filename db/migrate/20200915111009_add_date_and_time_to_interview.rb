class AddDateAndTimeToInterview < ActiveRecord::Migration[5.1]
  def change
    add_column :interviews, :start_date, :date
    add_column :interviews, :start_time, :time
    add_column :interviews, :end_date, :date
    add_column :interviews, :end_time, :time
  end
end
