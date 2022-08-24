# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_02_14_220943) do
  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "instructor_name"
    t.string "weekday_1"
    t.string "weekday_2"
    t.string "start_time"
    t.string "end_time"
    t.string "course_code"
    t.integer "capacity"
    t.integer "waitlist_capacity"
    t.string "status"
    t.string "room"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "instructor_id"
  end

  create_table "enrollments", force: :cascade do |t|
    t.string "course_id"
    t.string "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email_id"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_no"
    t.string "department"
    t.string "date_of_birth"
    t.string "major"
  end

  create_table "waitlists", force: :cascade do |t|
    t.string "course_id"
    t.string "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
