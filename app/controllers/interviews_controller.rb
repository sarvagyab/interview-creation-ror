class InterviewsController < ApplicationController
    
    # require 'date'

    def new
        @users = User.all
    end

    def create
        # fail
        if validateParams
                
            if interviewUpdates(1)
                @interview = Interview.last
                @interviewee = @interview.interviewee
                @interviewers = @interview.takingInterviews

                begin
                    # InterviewMailer.newInterview(@interview,@interviewee,@interviewers).deliver_later!
                    # InterviewMailer.reminderInterview(@interview.@interviewee,@interviewers).deliver_later!()
                rescue StandardError => err
                    flash[:errors] = "Sorry we could not send you the confirmation email but your interview has been scheduled."
                end

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
            if interviewUpdates(0)
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

    def destroy
        interview = Interview.find(params[:id])
        if interview.destroy
            flash[:notice] = "Deleted interview successfully"
        else
            flash[:errors] = interview.errors.full_messages
        end
        redirect_to :root
    end


private

    def get_interview_params
        params.permit(:name,:interviewee)
    end

    def validateParams
        required = [:name, :start_date, :start_time, :end_time, :interviewee, :interviewers]
        if required.all? {|k| params.has_key?(k) && params[k].present?}
        # here you know params has all the keys defined in required array
            if(validateName && validateInterviewers && validateInterviewee && validateTimings)
                return true
            else
                return false
            end
        else
            flash[:errors] = ["Please fill all fields completely"]
            return false
        end
        return true
    end

    def validateName
        if(params[:name].length < 3)
            flash[:errors] = ["Name should have at least 3 letters"]
            return false
        end
        return true
    end

    def validateInterviewee
        # puts "validating interviewees"
        if User.find(params[:interviewee])
            params[:interviewers].each do |id|
                # puts "interviewerr - "
                # puts id
                # puts ("interviewee - ")
                # puts params[:interviewee]

                if params[:interviewee] == id
                    flash[:errors] = ["Interviewer cannot be the same as interviewee"]
                    return false
                end
            end
            return true
        end
        return false
    end

    def validateInterviewers
        # puts "validating interviewers"
        if params[:interviewers].count > 0
            params[:interviewers].each do |id|
                unless User.find(id)
                    return false
                end
            end
            return true
        end
        flash[:errors] = ["Select at least 1 interviewer"]
        return false
    end

    def validateTimings
        @sdate = params[:start_date]
        @stime = params[:start_time]
        # @edate = params[:end_date]
        @etime = params[:end_time]

        @currentDate = getCurrentDate
        @currentTime = getCurrentTime

        @check = @currentTime<@stime
        # @check = (@currentDate< @sdate)
        # puts @currentTime
        # puts "current Date - " + @check + "Ending"
        # puts "current Date - " + @currentTime + "Ending"

        if @currentDate>@sdate || (@sdate == @currentDate && @currentTime>@stime)
            flash[:errors] = ["Interview Start Time should be greater than the current time"]
            return false
        end

        
        if(@etime<=@stime)
            flash[:errors] = ["Start time should be less than end time"]
            return false
        end

        User.find(params[:interviewee]).givingInterviews.each do |inter|
            if(params.has_key?(:id) && params[:id].present? && (params[:id].eql?inter.id.to_s))
                next
            end
            if intersectionTimings(@sdate,@stime,@etime,inter.start_time,inter.end_time)
                flash[:errors] = ["Interviewee already scheduled for another interview at that time"]
                return false
            end
        end
        params[:interviewers].each do |id|
            person = User.find(id)
            person.takingInterviews.each do |inter|
                if(params.has_key?(:id) && params[:id].present? && (params[:id].eql?inter.id.to_s))
                    next
                end
                if intersectionTimings(@sdate,@stime,@etime, inter.start_time,inter.end_time)
                    flash[:errors] = ["Interviewer #{person.name} already scheduled for another interview at that time"]
                    return false
                end 
            end
        end
        
        return true
    end

    def intersectionTimings(newDate,newStartTime,newEndTime, existingStartTime,existingEndTime)
        existingStartTime = existingStartTime.localtime
        existingEndTime = existingEndTime.localtime
        existingDate = existingStartTime.localtime.to_s[0..9]

        if newDate.to_s.eql?existingDate.to_s
            existingStartTime = existingStartTime.to_s[11..15]
            existingEndTime = existingEndTime.to_s[11..15]
            unless (newStartTime > existingEndTime || newEndTime < existingStartTime)
                return true
            end
        end
        return false
    end

    def getCurrentTime
        @currentTime = Time.new
        @hour = @currentTime.hour.to_s
        @minutes = @currentTime.min.to_s
        if(@hour.length == 1)
            @hour = "0" + @hour
        end
        if(@minutes.length == 1)
            @minutes = "0" + @minutes
        end
        @currentTime = @hour + ":" + @minutes
        return @currentTime
    end

    def getCurrentDate
        @currentDate = Time.new
        @month =  @currentDate.month.to_s
        @day =  @currentDate.day.to_s

        if(@month.length==1)
            @month = "0" + @month
        end

        if(@day.length==1)
            @day = "0" + @day
        end

        @currentDate = @currentDate.year.to_s + "-" + @month + "-" + @day

        return @currentDate
    end

    def interviewUpdates(instruction)
        begin
            Interview.transaction do
                Interviewer.transaction do
                    interviewInstance = acdrToInstruction(instruction)
                    params[:interviewers].each do |inter|
                        @userFetch = User.where(id:inter)
                        interviewInstance.takingInterviews.push(@userFetch)
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

    def acdrToInstruction(instruction)
        processedStartTime = Time.local(params[:start_date][0..3], params[:start_date][5..6], params[:start_date][8..9], params[:start_time].to_s[0..1], params[:start_time].to_s[3..4])
        processedEndTime = Time.local(params[:start_date][0..3], params[:start_date][5..6], params[:start_date][8..9], params[:end_time].to_s[0..1], params[:end_time].to_s[3..4])
        
        # puts(processedStartTime)
        # puts(processedEndTime)
        
        if instruction == 1
            return Interview.create!(
                name: params[:name],user_id: params[:interviewee], 
                start_time: processedStartTime,end_time: processedEndTime
            )
        else
            interviewUpdate = Interview.find(params[:id])
            interviewUpdate.update!(
                name: params[:name],user_id: params[:interviewee], 
                start_time: processedStartTime,end_time: processedEndTime
            )
            # check for error here too for exception later
            interviewUpdate.takingInterviews.delete_all
            return interviewUpdate
        end
    end

end
