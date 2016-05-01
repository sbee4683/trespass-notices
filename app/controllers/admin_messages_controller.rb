class AdminMessagesController < ApplicationController
    skip_before_action :require_login, only: [:new, :create]
    
    def index
        # Checks admin messages for already accepted requests
        # I don't like how I'm doing this.
        # I'd rather delete the adminMessage when sending user to create a new user
        adminMessages = AdminMessage.all
        adminMessages.each do |adminMessage|
            if User.find_by(email: adminMessage.msg)
                adminMessage.destroy
            end
        end
        
        @adminMessages = adminMessages.order(:created_at)
    end
  
    def new
        @adminMessage = AdminMessage.new
    end

    def create
        @adminMessage = AdminMessage.new(adminMessage_params)
        if User.find_by(email: adminMessage_params[:msg])
            flash[:danger] = "Account already exists!"
            redirect_to '/login'
        elsif @adminMessage.save
            flash[:success] = "Account successfully requested. An Administrator should be emailing you soon."
            redirect_to '/login'
        else
            flash[:danger] = "Account with email " + adminMessage_params[:msg] + " already requested. Contact Administrator"
            render 'new'
        end
    end
  
    def destroy
         @adminMessage = AdminMessage.find(params[:id])
         @adminMessage.destroy
         flash[:success] = "Message deleted"
         redirect_to admin_messages_url
    end
    
    private
    
    def adminMessage_params
        params.require(:admin_message).permit(:msg, :msgType)
    end
end