class UsersController < ApplicationController
    before_action :correct_user, only: [:edit, :update]
    before_action :admin_user, only: [:index, :new, :update, :destroy]
    helper_method :sort_column, :sort_direction
    
    def show
        @user = User.find(params[:id])
    end

    def new
        @user = User.new
    end
  
    def create
        @user = User.new(user_params)
        if @user.save
            flash[:success] = "Account for " + @user.username + " created!"
            redirect_to '/useradmin'
        else
            render 'new'
        end
    end
    
    def edit
        @user = User.find(params[:id])
    end
    
    def update
        @user = User.find(params[:id])
        if @user.update_attributes(user_params)
            flash[:success] = "Profile updated"
            redirect_to root_url
        else
            render 'edit'
        end
    end
    
    def index
        @users = User.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    end
    
    def destroy
        @user = User.find(params[:id])
        flash[:success] = "Account for " + @user.username + " was deleted!"
        @user.destroy
        redirect_to '/useradmin'
    end
    
    private
    
    def user_params
        params.require(:user).permit(:name, :username, :usertype, :email, 
                                     :password, :password_confirmation)
    end
    
    def correct_user
        @user = User.find(params[:id])
        redirect_to root_url unless current_user?(@user) || admin?
    end
    
    def admin_user
        @user = current_user
        redirect_to root_url unless admin?
    end
    
    def sort_column
        User.column_names.include?(params[:sort]) ? params[:sort] : "name"
    end
    
    def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end