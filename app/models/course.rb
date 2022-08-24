class Course < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :weekday_1, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :course_code, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :waitlist_capacity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :room, presence: true
end
