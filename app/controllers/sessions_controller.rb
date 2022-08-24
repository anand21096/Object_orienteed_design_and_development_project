class SessionsController < ApplicationController

  skip_before_action :ifNotLoggedin, only: %i[ new , create]

  def new
  end

  def create
   @user = User.find_by(email_id: params[:email_id])
   if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
   else
      redirect_to '/login', notice: "Email and Password did not match"
   end
end

  def logout
    session[:user_id] = nil
    redirect_to root_path
  end

end
