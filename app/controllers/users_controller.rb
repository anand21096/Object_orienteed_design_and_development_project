class UsersController < ApplicationController
  skip_before_action :ifNotLoggedin, only: %i[ new , create]

  def index
    if(current_user.identifier != "0")
      redirect_to '/', notice: "#{current_user.username} you are not allowed to view all"
    end
    @users = User.all
  end

  def new
    @user=User.new
  end

  def show
    if(current_user.id.to_s != params[:id] and current_user.identifier != "0")
      redirect_to '/', notice: "#{current_user.username} you are not allowed to view other's profile"
    end
    @user = User.find(params[:id])
  end

  def edit
    if(current_user.id.to_s != params[:id] and current_user.identifier != "0")
      redirect_to '/', notice: "#{current_user.username} you are not allowed to change other's profile"
    end
    @user = User.find(params[:id])
  end

  def create
   @user = User.create(params.require(:user).permit(:username,
   :password,:email_id,:identifier, :phone_no, :department, :date_of_birth, :major))
   p current_user
   if !current_user
      session[:user_id] = @user.id
   end
   redirect_to root_path, notice: "User Created"
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(params.require(:user).permit(:username,
        :password,:email_id,:identifier, :phone_no, :department, :date_of_birth, :major))
        format.html { redirect_to user_url(@user), notice: "user was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])

    # If student is deleted, all enrollemnts and waitlists should be deleted and course should be updated
    if (@user.identifier == "1")
      Waitlist.where(student_id: @user.id.to_s ).destroy_all
      enrollments = Enrollment.where(student_id: @user.id.to_s )
      enrollments.each do |enrollment|

        # Once enrollment is dropped update the enrollment with waitlisted student and update the course status
        
        enrollment.destroy

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

      end


    end

    # # If instructor is deleted, all courses, enrollemnts and waitlists should be deleted
    if (@user.identifier == "2")
      coursesForThisInstructor = Course.where(instructor_id: @user.id.to_s)
      coursesForThisInstructor.each do |course|
        course_id = course["name"]
        Enrollment.where(course_id: course_id ).destroy_all
        Waitlist.where(course_id: course_id ).destroy_all
        course.destroy
      end
    end


    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email_id, :phone_no, :department, :date_of_birth, :major)
    end
end
