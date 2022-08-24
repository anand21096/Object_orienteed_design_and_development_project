class ApplicationController < ActionController::Base
helper_method :current_user
helper_method :logged_in?
before_action :ifNotLoggedin
def current_user
   User.find_by(id: session[:user_id])
end
def logged_in?
    !current_user.nil?
end


def ifNotLoggedin
    redirect_to '/login', notice: "Please login"  unless !current_user.nil?
end

def home
end

end
