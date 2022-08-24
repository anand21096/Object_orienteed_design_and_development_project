# Object_orienteed_design_and_development_project

# ECE 517 Project 2

# Admin Credentials

email:    aksaks@ncsu.edu
password: password

# Various Features

1. Student can view all the courses by clicking on View Courses button in the nav bar
2. Student can enroll into a course by clicking on Enroll button in nav bar.
3. Student can enter waitlist by clicking on Enter Waitlist button in nav bar.
4. Admin and Instructor can enroll a student by clicking on Enroll a Student button in nav bar.
5. Admin and Instructor can waitlist a student by clicking on Waitlist a Student button in nav bar.
6. Student can view their Enrollments and Waitlist through My Enrollments and My Waitlists buttons in nav bar. Students can delete their enrollments and waitlists from this page.
7. To view their profile, anyone can click on Edit Profile button in nav bar and click on View User link.
8. Admin can click on "All Students and Instructors" button and edit the user. To delete the user admin should click on edit user link and click on Delete User button.
9. To verify if all the fields of students and instructors are present, login as Admin and check the details of all the users by clickin on "All Students and Instructors" button.
10. Instructor can view the students enrolled and waitlisted in his/her courses by clicking on "Enrollments in My Courses" and "Waitlists in My Courses" buttons in nav bar.
11. Instructor can view his courses by clicking on "View My Courses" button in nav bar.
12. Admin and Instructor can create a course by clicking on "Create Course" button in nav bar.
13. Admin or Instructor can delete a course by clicking on "Show this Course" link and then by clicking "Delete Course"


# Edge Cases

Once the instructor is deleted, all the enrollments and waitlists for instructor's courses will be deleted. To check this login as admin and check the "All Enrollments" and "All Waitlists" button after deletion.

If Student is deleted, all his Enrollments and Waitlists are automatically destroyed. To check this login as admin and check the "All Enrollments" and "All Waitlists" button after deletion.

If Course is deleted, all the Enrollments and Waitlists of this course are automatically destroyed. To check this login as admin and check the "All Enrollments" and "All Waitlists" button after deletion.

Students cannot access other users profiles by changing the URL.

# Testing

Testing is done for Enrollment model
