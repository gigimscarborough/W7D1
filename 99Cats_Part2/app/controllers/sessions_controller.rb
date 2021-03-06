class SessionsController < ApplicationController

    before_action :logged_in_redirect, only: [:create, :new]

    def new
        @user = User.new
        render :new
    end

    def create
        user = User.find_by_credentials(
            params[:user][:user_name], 
            params[:user][:password])

        if user
            login_user!(user)
        else
            flash.now[:errors] = ['Invalid Credentials']
            render :new
        end
    end

    def destroy
        # current_user.reset_session_token!
        # session[:session_token] = nil
        self.logout
        redirect_to new_session_url
    end 

end
