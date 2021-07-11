class AddColumnsToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :scheduled_end_time, :datetime
    add_column :attendances, :next_day, :integer
    add_column :attendances, :office_work_contents, :string
    add_column :attendances, :instructor_confirmation_stamp, :string
    add_column :attendances, :month_attendances_approval_stamp, :string
    add_column :attendances, :month_attendances_approval_status, :string, default: "未申請"
    add_column :attendances, :month, :string
    add_column :attendances, :month_attendances_approval_change, :integer
    add_column :attendances, :change_application_started_time, :datetime
    add_column :attendances, :change_application_finished_time, :datetime
    add_column :attendances, :change_application_worked_time, :integer
    add_column :attendances, :change_application_stamp, :string
    add_column :attendances, :change_application_status, :string
    add_column :attendances, :change_application_next_day, :integer
    add_column :attendances, :change_application_change, :integer
    add_column :attendances, :change_application_note, :string
    add_column :attendances, :before_change_started_time, :datetime
    add_column :attendances, :before_change_finish_time, :datetime
  end
end
