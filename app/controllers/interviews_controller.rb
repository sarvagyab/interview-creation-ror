class InterviewsController < ApplicationController
    

    def index 
        @interviews = Interview.all
    end

    def show
        @interview = Interview.find(params[:id])
        @interviewers = @interview.takingInterviews
    end

    def edit
        @interview = Interview.find(params[:id])
        @interviewers = @interview.takingInterviews
    end

    def new

    end

end
