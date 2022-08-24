class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :description
      t.string :instructor_name
      t.string :weekday_1
      t.string :weekday_2
      t.string :start_time
      t.string :end_time
      t.string :course_code
      t.integer :capacity
      t.integer :waitlist_capacity
      t.string :status
      t.string :room

      t.timestamps
    end
  end
end
