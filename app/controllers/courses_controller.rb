class CoursesController < ApplicationController
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1 or /courses/1.json
  def show
  end

  def instructor
    @courses = Course.where(instructor_id: current_user["id"])
  end

  # GET /courses/new
  def new
    if session[:user_id] != nil
      if current_user.identifier == "1"
        redirect_to '/', notice: "Sorry you are not authorized to create a course"
      end
    end
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    
    course = Course.find_by(id: params[:id])
    if(current_user.id.to_s != course["instructor_id"] and current_user.identifier == "2")
      redirect_to '/courses', notice: 'You are not allowed to edit the courses that are not yours'
      return
    end

    if(current_user.identifier == "1")
      redirect_to '/courses', notice: 'You are not allowed to edit the courses'
      return
    end

  end

  # POST /courses or /courses.json
  def create

    if current_user.identifier == "2" and course_params["instructor_id"].to_i != current_user.id
      redirect_to '/courses/new', notice: "Sorry you are not authorized to create a course for other instructor"
      return
    end
    
    @course = Course.new(course_params)

    #Set course capacity to OPEN when created
    @course["status"] = "OPEN"
  
    instructor = User.find_by(id: course_params["instructor_id"].to_i)
    instructor_name = instructor["username"]
    @course["instructor_name"] = instructor_name

    respond_to do |format|
      if @course.save
        format.html { redirect_to course_url(@course), notice: "Course was successfully created." }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to course_url(@course), notice: "Course was successfully updated." }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy

    course_id = @course["name"]
    Enrollment.where(course_id: course_id ).destroy_all
    Waitlist.where(course_id: course_id ).destroy_all

    respond_to do |format|
      format.html { redirect_to courses_url, notice: "Course was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name, :description, :instructor_name, :weekday_1, :weekday_2, :start_time, :end_time, :course_code, :capacity, :waitlist_capacity, :status, :room, :instructor_id)
    end
end
