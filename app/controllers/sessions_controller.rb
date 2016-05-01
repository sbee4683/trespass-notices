class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]
  
  def new
    if logged_in?
      redirect_to root_url
    end
  end
  
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      log_in user
      redirect_to root_url
    else
      flash.now[:danger] = 'Invalid username/password combination'
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
