require "test_helper"

class EnrollmentTest < ActiveSupport::TestCase
  test "should not save Enrollment without course id and student id" do
    enrollment = Enrollment.new
    assert_not enrollment.save
  end
  test "should save Enrollment with all fields" do
    enrollment = enrollments(:one)
    assert enrollment.save
  end
end
