class UsersController < ApplicationController
    def index 
        @users = User.all
        respond_to do |format|
            format.html
            format.json{ render json: @users}
        end
    end

    def show
        @user = User.find(params[:id])
        respond_to do |format|
            format.html
            format.json{ render json: @user}
        end
    end

    def new

    end

    def destroy
        user = User.find(params[:id])
        takingInters = user.takingInterviews

        takingInters.each do |inter|
            if(inter.takingInterviews.length() == 1)
                unless inter.destroy
                    flash[:errors] = ["Could not delete all interviews with only this user as interviewer due to following reasons"] + inter.errors.full_messages
                end
            end
        end

        respond_to do |format|
            if user.destroy
                flash[:notice] = "User successfully deleted"
                format.json{render json:{notice:flash[:notice],errors:flash[:errors]}}
            else
                flash[:errors] += user.errors.full_messages
                format.json{ render json:{errors:flash[:errors]},status: :not_acceptable}    
            end
            format.html{redirect_to users_path}
        end
    end

    def edit
        @user = User.find(params[:id]);
    end


    def update
        user = User.find(params[:id])
        respond_to do |format|
            if user.update(user_params)
                flash[:notice] = "User Details Successfully Updated"
                format.html{redirect_to users_path}
                format.json{render json:{notice:flash[:notice]}}
            else
                flash[:errors] = user.errors.full_messages
                format.html{redirect_to edit_user_path(params[:id])}
                format.json{render json:{errors:flash[:errors]}, status: :not_acceptable};
            end
        end
    end


    def create 
        @user = User.new(user_params)
        respond_to do |format|
            if (@user.save)
                flash[:notice] = "User successfully added";
                format.html{ redirect_to users_path}
                format.json{ render json: { notice: flash[:notice]}}
            else
                flash[:errors] = @user.errors.full_messages
                format.html{ redirect_to new_user_path }
                format.json{ render json: {errors: flash[:errors]},status: :not_acceptable}
            end
        end
    end

private

    def user_params
        params.permit(:name,:email)
    end

end
