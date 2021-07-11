# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20210601124129) do

  create_table "attendances", force: :cascade do |t|
    t.date "worked_on"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.string "note"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "scheduled_end_time"
    t.integer "next_day"
    t.string "office_work_contents"
    t.string "instructor_confirmation_stamp"
    t.string "month_attendances_approval_stamp"
    t.string "month_attendances_approval_status", default: "未申請"
    t.string "month"
    t.integer "month_attendances_approval_change"
    t.datetime "change_application_started_time"
    t.datetime "change_application_finished_time"
    t.integer "change_application_worked_time"
    t.string "change_application_stamp"
    t.string "change_application_status"
    t.integer "change_application_next_day"
    t.integer "change_application_change"
    t.string "change_application_note"
    t.datetime "before_change_started_time"
    t.datetime "before_change_finish_time"
    t.string "instructor_confirmation_status"
    t.integer "overtime_approval_change"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "base_points", force: :cascade do |t|
    t.string "base_point_name"
    t.string "base_point_type"
    t.integer "base_point_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "department"
    t.datetime "basic_time", default: "2021-07-08 23:00:00"
    t.datetime "work_time", default: "2021-07-08 22:30:00"
    t.boolean "superior", default: false
    t.string "affiliation"
    t.integer "employee_number"
    t.string "uid"
    t.datetime "basic_work_time"
    t.datetime "designated_work_start_time"
    t.datetime "designated_work_end_time"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
