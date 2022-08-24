class WaitlistsController < ApplicationController
  before_action :set_waitlist, only: %i[ show edit update destroy ]

  # GET /waitlists or /waitlists.json
  def index
    user_id = current_user.id.to_s
    @waitlists = Waitlist.where(student_id: user_id)
  end

  def allWaitlist
    @waitlists = Waitlist.all
  end
  # GET /waitlists/1 or /waitlists/1.json
  def show
  end

  # GET /waitlists/new
  def new
    @waitlist = Waitlist.new
  end

  # GET /waitlists/1/edit
  def edit
  end

  def myCourseWaitlists
    @courses = Course.where(instructor_id: current_user.id.to_s)
  end

  # POST /waitlists or /waitlists.json
  def create
    @waitlist = Waitlist.new(waitlist_params)
    course = Course.find_by(name: waitlist_params["course_id"])

    enrollingStudent = User.find_by(id: waitlist_params["student_id"].to_i)

    p enrollingStudent

    if(!enrollingStudent or enrollingStudent["identifier"] != "1")
      redirect_to '/waitlists/new', notice: "Student with id #{waitlist_params["student_id"]} doesn't exist"
      return
    end


    if(current_user.id.to_s != waitlist_params["student_id"] and current_user.identifier == "1")
      redirect_to '/waitlists/new', notice: 'You are not allowed to waitlist other students'
      return
    end
    

    if(current_user.id.to_s != course["instructor_id"] and current_user.identifier == "2")
      redirect_to '/waitlists/new', notice: 'You are not allowed to waitlist students in courses that are not yours'
      return
    end

    isEnrolled = Enrollment.where(course_id: waitlist_params["course_id"], student_id: waitlist_params["student_id"]).count
    isWaitlist = Waitlist.where(course_id: waitlist_params["course_id"], student_id: waitlist_params["student_id"]).count
    if(isEnrolled == 1 || isWaitlist == 1 )
      redirect_to '/waitlists/new', notice: 'You already enrolled or waitlisted for this course'
      return
    end


    noOfWaitlist = Waitlist.where(course_id: waitlist_params["course_id"]).count
    waitlistCapacity = course["waitlist_capacity"]

    respond_to do |format|
      if @waitlist.save
        if(noOfWaitlist+1 == waitlistCapacity)
          course.update(status: 'CLOSED')
        end
        format.html { redirect_to waitlist_url(@waitlist), notice: "Waitlist was successfully created." }
        format.json { render :show, status: :created, location: @waitlist }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @waitlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /waitlists/1 or /waitlists/1.json
  def update
    respond_to do |format|
      if @waitlist.update(waitlist_params)
        format.html { redirect_to waitlist_url(@waitlist), notice: "Waitlist was successfully updated." }
        format.json { render :show, status: :ok, location: @waitlist }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @waitlist.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /waitlists/1 or /waitlists/1.json
  def destroy
    @waitlist.destroy

    course = Course.find_by(name: @waitlist["course_id"])
    courseStatus = course["status"]

    noOfWaitlist = Waitlist.where(course_id: @waitlist["course_id"]).count

    if(courseStatus == "CLOSED")
      course.update(status: 'WAITLIST')
    end

    respond_to do |format|
      format.html { redirect_to waitlists_url, notice: "Waitlist was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_waitlist
      @waitlist = Waitlist.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def waitlist_params
      params.require(:waitlist).permit(:course_id, :student_id)
    end
end
