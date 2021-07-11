class AddInstructorConfirmationStatusToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :instructor_confirmation_status, :string
  end
end
