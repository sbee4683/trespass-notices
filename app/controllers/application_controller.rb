class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :require_login
  
  private
  
  def require_login
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
end