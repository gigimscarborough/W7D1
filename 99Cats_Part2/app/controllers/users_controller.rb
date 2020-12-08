class UsersController < ApplicationController

    before_action :logged_in_redirect, only: [:create, :new]
    
    def new
        @user = User.new
        render :new
    end

    def create
        @user = User.new(user_params)

        if @user.save
           login_user!(@user)
           redirect_to cats_url 
        else
            flash.now[:errors] = @user.errors.full_messages #will be called in our view when we return to new
            render :new
        end

    end

    private

    def user_params
        params.require(:user).permit(:user_name, :password)
    end

end
