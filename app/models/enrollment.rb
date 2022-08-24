class Enrollment < ApplicationRecord

  validates :course_id, presence: true
  validates :student_id, presence: true
end
