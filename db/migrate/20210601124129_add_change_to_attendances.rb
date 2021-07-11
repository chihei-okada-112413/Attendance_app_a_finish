class AddChangeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_approval_change, :integer
  end
end
