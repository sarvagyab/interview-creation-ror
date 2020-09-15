class InterviewsController < ApplicationController
    
    def new
        @users = User.all
    end

    def create
        # fail
        if validateParams
                
            if createInterviewers
                flash[:notice] = "Successfully added the interview"
                redirect_to :root
            else
                # flash[:errors] = ["Could not add the interview"]
                redirect_to new_interview_path
            end
        else
            redirect_to new_interview_path
        end
    end

    def index 
        @interviews = Interview.all
    end

    def show
        @interview = Interview.find(params[:id])
        @interviewers = @interview.takingInterviews
    end

    def edit
        @interview = Interview.find(params[:id])
        @users = User.all
        @interviewers = @interview.takingInterviews
    end

    def update
        if validateParams  
            if updateInterviewers
                flash[:notice] = "Successfully edited the interview"
                redirect_to :root
            else
                # flash[:errors] = ["Could not add the interview"]
                redirect_to edit_interview_path(params[:id])
            end
        else
            redirect_to edit_interview_path(params[:id])
        end
    end


private

    def get_interview_params
        params.permit(:name,:interviewee)
    end

    def validateParams
        return true
    end
    

    def createInterviewers
        begin
            Interview.transaction do
                Interviewer.transaction do
                    newInterview = Interview.create!(name: params[:name],user_id: params[:interviewee])
                    params[:interviewers].each do |inter|
                        @userFetch = User.where(id:inter)
                        newInterview.takingInterviews.push(@userFetch)
                        # Interviewer.create!(interview_id:interviewUpdate.id,user_id:inter)
                    end
                end
            end
        rescue  ActiveRecord::RecordInvalid => invalid
            flash[:errors] = invalid.record.errors
            return false
        rescue StandardError => error
            flash[:errors] = ["Sorry some interval server error has prevented the interview from being created. We are looking into it. Thank you for your patience."]
            return false
        end

        return true
    end

    def updateInterviewers
        begin
            Interview.transaction do
                Interviewer.transaction do
                    interviewUpdate = Interview.find(params[:id])
                    interviewUpdate.update!(name: params[:name],user_id: params[:interviewee])

                    # check for error here too for exception later
                    interviewUpdate.takingInterviews.delete_all
                    
                    params[:interviewers].each do |inter|
                        @userFetch = User.where(id:inter)
                        interviewUpdate.takingInterviews.push(@userFetch)
                        # Interviewer.create!(interview_id:interviewUpdate.id,user_id:inter)
                    end
                end
            end
        rescue  ActiveRecord::RecordInvalid => invalid
            flash[:errors] = invalid.record.errors
            return false
        rescue StandardError => error
            flash[:errors] = ["Sorry some interval server error has prevented the interview from being created. We are looking into it. Thank you for your patience."]
            return false
        end

        return true
    end


end
