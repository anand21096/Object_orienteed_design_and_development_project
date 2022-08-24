class HomeController < ApplicationController
  skip_before_action :ifNotLoggedin
  def index
  end
end
