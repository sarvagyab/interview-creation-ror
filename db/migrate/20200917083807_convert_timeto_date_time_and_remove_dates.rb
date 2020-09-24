class ConvertTimetoDateTimeAndRemoveDates < ActiveRecord::Migration[5.1]
  def change
    connection.execute("PRAGMA defer_foreign_keys = ON")
    connection.execute("PRAGMA foreign_keys = OFF")
    
    change_column :interviews, :start_time, :datetime
    change_column :interviews, :end_time, :datetime
    remove_column :interviews, :start_date
    remove_column :interviews, :end_date

    connection.execute("PRAGMA foreign_keys = ON")
    connection.execute("PRAGMA defer_foreign_keys = OFF")
  end
end
