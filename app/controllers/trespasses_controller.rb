class TrespassesController < ApplicationController
    before_action :dispatch_user, only: [:new, :create, :edit, :update]
    #helper_method :sort_column, :sort_direction
    
    def index
        @trespasses = Trespass.search(params).order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 10)
    end
    
    def new
        @trespass = Trespass.new
    end
    
    def create
        @trespass = Trespass.new(trespass_params, modifiedBy: current_user, archived: false)
        if @trespass.dateOfNotification
            @trespass.dateOfExpiration = @trespass.dateOfNotification.years_since(1)
        end
        
        if @trespass.save
            flash[:success] = "Trespass Notice for " + @trespass.subjName + " created!"
            redirect_to root_url
        else
            render 'new'
        end
    end
    
    def edit
        @trespass = Trespass.find(params[:id])
    end
    
    def update
        @trespass = Trespass.find(params[:id])
        if @trespass.update_attributes(trespass_params)
            flash[:success] = "Trespass Notice for " + @trespass.subjName + " updated!"
            redirect_to root_url
        else
            render 'edit'
        end
    end
    
    private
    
    def trespass_params
        params.require(:trespass).permit(:caseNum, :locationName, :locationAddr, 
                                         :subjName, :subjDOB, :dateOfNotification, 
                                         :modifiedBy, :archived)
    end
    
    def dispatch_user
        @user = current_user
        redirect_to root_url unless dispatcher? || admin?
    end
    
    # Used for sorting tables
    def sort_column
        Trespass.column_names.include?(params[:sort]) ? params[:sort] : "dateOfNotification"
    end
    
    def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end