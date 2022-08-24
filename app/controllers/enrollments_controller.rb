class EnrollmentsController < ApplicationController
  before_action :set_enrollment, only: %i[ show edit update destroy ]

  # GET /enrollments or /enrollments.json
  def index
    user_id = current_user.id.to_s
    @enrollments = Enrollment.where(student_id: user_id)
  end

  def allenrollments
    @enrollments = Enrollment.all
  end


  # GET /enrollments/1 or /enrollments/1.json
  def show
  end

  # GET /enrollments/new
  def new
    @enrollment = Enrollment.new
  end

  # GET /enrollments/1/edit
  def edit
  end

  # POST /enrollments or /enrollments.json
  def create

    @enrollment = Enrollment.new(enrollment_params)
    course = Course.find_by(name: enrollment_params["course_id"])

    enrollingStudent = User.find_by(id: enrollment_params["student_id"].to_i)

    if(!enrollingStudent or enrollingStudent["identifier"].to_i != 1)
      redirect_to '/enrollments/new', notice: "Student with id #{enrollment_params["student_id"]} doesn't exist"
      return
    end

    # if logged in student is not the one enrolling

    if(current_user.id.to_s != enrollment_params["student_id"] and current_user.identifier == "1")
      redirect_to '/enrollments/new', notice: 'You are not allowed to enroll other students'
      return
    end
    
    # instructor should not be able to enroll studnets for other courses

    if(current_user.id.to_s != course["instructor_id"] and current_user.identifier == "2")
      redirect_to '/enrollments/new', notice: 'You are not allowed to enroll students in courses that are not yours'
      return
    end


    isEnrolled = Enrollment.where(course_id: enrollment_params["course_id"], student_id: enrollment_params["student_id"]).count
    if(isEnrolled == 1)
      redirect_to '/enrollments/new', notice: 'Already enrolled into this course'
      return
    end

    # course_id in Enrollment is name in Course

    noOfEnrollments = Enrollment.where(course_id: enrollment_params["course_id"]).count
    noOfWaitlist = Waitlist.where(course_id: enrollment_params["course_id"]).count
    courseCapacity = course["capacity"]
    waitlistCapacity = course["waitlist_capacity"]

    if(noOfEnrollments >=  courseCapacity) 
      redirect_to '/courses', notice: 'This course is full'
      return
    end


    respond_to do |format|
      if @enrollment.save
        # condition to close the course
        if(noOfEnrollments+1 == courseCapacity && (noOfWaitlist == waitlistCapacity) )
          course.update(status: 'CLOSED')
        elsif (noOfEnrollments+1 == courseCapacity && (noOfWaitlist < waitlistCapacity) )
          course.update(status: 'WAITLIST')
        end
        format.html { redirect_to enrollment_url(@enrollment), notice: "You are enrolled succesfully." }
        format.json { render :show, status: :created, location: @enrollment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /enrollments/1 or /enrollments/1.json
  def update
    respond_to do |format|
      if @enrollment.update(enrollment_params)
        format.html { redirect_to enrollment_url(@enrollment), notice: "Enrollment was successfully updated." }
        format.json { render :show, status: :ok, location: @enrollment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @enrollment.errors, status: :unprocessable_entity }
      end
    end
  end

  def myCourseEnrollments
    @courses = Course.where(instructor_id: current_user.id.to_s)
  end

  # DELETE /enrollments/1 or /enrollments/1.json
  def destroy
    enrollment = @enrollment
    @enrollment.destroy

    course_id = enrollment["course_id"]
    student_id = enrollment["student_id"]

    noOfWaitlist = Waitlist.where(course_id: enrollment["course_id"]).count
    course = Course.find_by(name: enrollment["course_id"])
    courseCapacity = course["capacity"]
    waitlistCapacity = course["waitlist_capacity"]

    if(noOfWaitlist > 0)
      # Move Eaitlist sutdents to enroll
      firstWaitlits = Waitlist.where(course_id: enrollment["course_id"]).limit(1).order('created_at desc')
      firstWaitlistStudent = ""
      firstWaitlits.each do |firstWaitlit|
        firstWaitlistStudent = firstWaitlit["student_id"]
        firstWaitlit.destroy
        newEnrollement = Enrollment.new(course_id: course_id, student_id: firstWaitlistStudent)
        newEnrollement.save
        noOfWaitlist = noOfWaitlist -1
      end

    end

    noOfEnrollments = Enrollment.where(course_id: enrollment["course_id"]).count

    if(course["status"] == "CLOSED" || course["status"] == "WAITLIST")
      #Move it to waitlist
      if(noOfEnrollments == courseCapacity && waitlistCapacity > noOfWaitlist)
        course.update(status: 'WAITLIST')
      elsif(noOfEnrollments < courseCapacity)
        course.update(status: 'OPEN')
      end
      #move it to open
    end

    respond_to do |format|
      format.html { redirect_to enrollments_url, notice: "Unenrolled student." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enrollment
      @enrollment = Enrollment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def enrollment_params
      params.require(:enrollment).permit(:course_id, :student_id)
    end
end
