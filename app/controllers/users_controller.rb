class UsersController < ApplicationController
    def index 
        @users = User.all
    end

    def show
        @user = User.find(params[:id])
    end

    def new

    end

    def destroy
        user = User.find(params[:id])
        if user.destroy
        else
            flash[:errors] = user.errors.full_messages
        end
        redirect_to users_path
    end

    def edit
        @user = User.find(params[:id]);
    end


    def update
        user = User.find(params[:id])
        if user.update(name:params[:name])
            redirect_to users_path
        else
            flash[:errors] = @user.errors.full_messages
            redirect_to edit_user_path(params[:id])
        end
    end


    def create 
        @user = User.new(user_params)
        if (@user.save)
            redirect_to users_path
        else
            flash[:errors] = @user.errors.full_messages
            redirect_to new_user_path
        end
    end

private

    def user_params
        params.permit(:name)
    end

end
