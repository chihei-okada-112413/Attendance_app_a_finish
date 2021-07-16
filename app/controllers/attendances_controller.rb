class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :overtime_application, :update_overtime, :overtime_application_approval, :update_application, :update_overtime_approval, :update_attendances_application ,:attendances_application_approval ,:update_attendances_application_approval, :update_attendances_change, :attendances_change_approval,:update_attendances_change_approval, :attendances_change_history_log]
  before_action :logged_in_user, only: [:update, :edit_one_month, :overtime_application, :update_overtime, :overtime_application_approval, :update_application , :update_overtime_approval,:attendances_change_paramspplication_approval,:update_attendances_change_approval]
  before_action :admin_or_correct_user, onry: [:update, :edit_one_month, :update_one_month, :overtime_application, :update_overtime, :overtime_application_approval, 
  :update_overtime_approval, :update_application, :update_attendances_application ,:attendances_application_approval,:update_attendances_application_approval, :update_attendances_change, :attendances_change_approval, :attendances_change_history_log]
  before_action :set_one_month, only: [:edit_one_month, :overtime_application, :overtime_application_approval, :update_attendances_application ,:update_attendances_application_approval, :update_attendances_change_approval, :attendances_change_history_log, :update_attendances_change]
  before_action :admin_user?, only:[:edit_one_month]
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    #debugger
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    # 出勤時間が未登録であることを判定します。
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        @attendance.update_attributes(before_change_started_time: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        @attendance.update_attributes(before_change_finish_time: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end


  def edit_one_month
    @attendance= Attendance.new()
  end
  
        #if !item[:started_at].nil? && item[:finished_at].blank?
        
       # else
        #attendance = Attendance.find(id)
        #attendance.update_attributes!(item)
        #end
  
  
  def update_one_month
    ActiveRecord::Base.transaction do # トランザクションを開始
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      end
    end
    flash[:success] = "1か月間の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] ="無効な入力データがあった為、更新をキャンセルされました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end

  def attendances_change_history_log
    @attendances = @user.attendances.where(change_application_status: "承認")
#debugger
  
    @y=Date.today.year
    @m=Date.today.month
    

    #@attendances=@user.attendances.where(change_application_status: "申請中") if 
    
    #@eday = params[:y] + "-" + "0" +params[:m] + "-30"
    #debugger

    if params[:y] && params[:m] 
      if params[:y] != "年" && params[:m]  != "月"
        @fday = params[:y] + "-" + "0" +params[:m] + "-01"
        @eday = @fday.to_date.end_of_month.to_s
        #debugger
        if @y = params[:y]
          if @m = params[:m]
          @attendances = @user.attendances.where(change_application_status: "承認", worked_on: @fday..@eday)
          end
        end
      end
    else
      #redirect_to attendances_attendances_change_history_log_user_path
    end
    
    

    
    
    #debugger
  end


  def update_attendances_change
    #debugger
    @count = 0
    ActiveRecord::Base.transaction do
    update_attendances_change_params.each do |id, item|
      attendance = Attendance.find(id)
      #debugger
        if update_attendances_change_params[id][:change_application_stamp].present?
            #if update_attendances_change_params[id][:change_application_note].blank?
            #  raise ActiveRecord::RecordInvalid
            #end
            if update_attendances_change_params[id]["change_application_finished_time(4i)"] == "" || update_attendances_change_params[id]["change_application_finished_time(5i)"] == "" 
              raise ActiveRecord::RecordInvalid
            else
            #@attendance = attendance
            attendance.update_attributes!(item)
            attendance.update(change_application_status: params[:change_application_status])
            # if update_attendances_change_params["125"]["change_application_finished_time(4i)"] == ""

            end
        else
          @count += 1
        end
        #end
          #@count += 1
    end
    if @count == @one_month.count
      raise ActiveRecord::RecordInvalid
    end 
    end
    flash[:success]="勤怠変更申請を行いました。"
    redirect_to attendances_edit_one_month_user_url
  rescue ActiveRecord::RecordInvalid
    #errors.add(:change_application_started_time, "より早い退勤時間は無効です2")
    #debugger
    #if @count == 0 
      #User.find(params[:id]).attendances.where(month: params[:date].to_date.month.to_s, change_application_stamp: "").count == @one_month.count
    flash[:danger]="入力データが無効です。"
    #else
    #flash[:success]="勤怠変更申請を行いました。"
    #end
    redirect_to attendances_edit_one_month_user_url
  end

  def attendances_change_approval
    @users_attendances_change_approval_jyotyo_a = User.where(id: Attendance.where(change_application_status: "申請中", change_application_stamp: "上長1").select(:user_id).order(nil))
    @users_attendances_change_approval_jyotyo_b = User.where(id: Attendance.where(change_application_status: "申請中", change_application_stamp: "上長2").select(:user_id).order(nil))
  end

  def update_attendances_change_approval
    update_attendances_change_apploval_params.each do |id, item|
      #debugger
      if params[:user][:attendances][id][:change_application_change] == "1"
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
      if update_attendances_change_apploval_params[id][:change_application_status] == "なし"
          attendance.update(change_application_started_time: nil, change_application_finished_time: nil, change_application_stamp: nil,change_application_note: nil, change_application_status: nil) 
      elsif update_attendances_change_apploval_params[id][:change_application_status] == "否認"
      
      else
        attendance.update(started_at: attendance.change_application_started_time)
        attendance.update(finished_at: attendance.change_application_finished_time)
        if attendance.before_change_started_time.nil?
          if attendance.started_at.present?
          attendance.update(before_change_started_time: attendance.started_at)
          end
        end
        if attendance.before_change_finish_time.nil?
          if attendance.finished_at.present?
            attendance.update(before_change_finish_time: attendance.finished_at)
          end
        end
      end

      end
    end
    redirect_to user_url
  end
  
  # 一か月分の勤怠 申請
  def update_attendances_application
    #debugger
    #@attendance = @user.attendances
    ActiveRecord::Base.transaction do
      if params[:attendance][:month_attendances_approval_stamp] == ""
      flash[:danger]="申請者を選択してください。"
      else
        @attendances.each do |at|
        #debugger
        at.update_attributes!(attendances_application_params)
        at.update(month: format("%02d", params[:date].to_date.month.to_s ) + User.find(at.user_id).uid)
        
        end
        flash[:success]="所属長承認を申請しました。"
      end
    end
    #debugger
    redirect_to @user
  end

  # 一か月分の勤怠 申請 確認
  def attendances_application_approval
    @month_check = ""
    @users_attendances_application_approval_jyotyo_a = User.where(id: Attendance.where(month_attendances_approval_status: "申請中", month_attendances_approval_stamp: "上長1").select(:user_id))
    @users_attendances_application_approval_jyotyo_b = User.where(id: Attendance.where(month_attendances_approval_status: "申請中", month_attendances_approval_stamp: "上長2").select(:user_id))
    #@attendances = Attendance.where(month_attendances_approval_status: "申請中").group(:month)
    #debugger
  end

  # 一か月分の勤怠 申請 承認
  def update_attendances_application_approval
    #@attendance = params[:user][:attendance][:month_attendances_approval_status]
    #debugger
    
    update_attendances_application_params.each do |id, item|
      #attendance = Attendance.find(id)
      user = User.find(Attendance.find(id).user_id)#User.find(id: Attendance.find(id).user_id)
      userid= user.id
      #debugger
      user_month = Attendance.find(id).month
      #user_id = user[:id]
      #debugger
      @attendances = Attendance.where(month: user_month, user_id: userid)
      #@user= user.attendances
      #debugger
        @attendances.each do |at|
          if params[:user][:attendances][id][:month_attendances_approval_change] == "1"
            at.update_attributes!(item)
            at.update(month: nil)
            if update_attendances_application_params[id][:month_attendances_approval_status] == "なし"
              at.update(month_attendances_approval_status: nil, month_attendances_approval_change: nil, month_attendances_approval_stamp: nil, month: nil) 
            end
          end
        end
        
      
      #debugger
        #user.each do |u|
        #  u.attendances.whrer(month: params[:date].to_date.month)
        #end
    end


    #@attendances.each do |at|
      #at.update_attributes!(update_attendances_application_params)
      #at.update(month_attendances_approval_status: params[:user][:attendance][:month_attendances_approval_status], month_attendances_approval_change: params[:user][:attendance][:month_attendances_approval_change])
    #end
    redirect_to @user

  end

  # 残業 申請
  def overtime_application
    @user = User.find(params[:id])  
    @attendance = Attendance.find(params[:day])
    #debugger
  end

  # 残業 申請 登録
  def update_overtime
    #debugger
    #if params[]
      overtime_application_params.each do |id, item|
        if params[:user][:attendances][id][:instructor_confirmation_stamp] == ""
          flash[:danger]="申請者を選択してください。"
        else
          attendance = Attendance.find(id)
          attendance.update_attributes!(item)
          #attendance.scheduled_end_time.change(year: "2000")#params[:user][:attendances][id][:time_year], month: params[:user][:attendances][id][:time_month], day: params[:user][:attendances][id][:time_day])
          flash[:success]="残業申請を行いました。"
        end
      end
    redirect_to @user
  end

  # 残業 申請 確認
  def overtime_application_approval
    
    @users = User.where(id: Attendance.where(instructor_confirmation_status: "申請中").select(:user_id))
    @attendance = Attendance.where(instructor_confirmation_status: "申請中")
    #debugger
  end

  # 残業 申請 承認
  def update_overtime_approval
    #debugger
    #if params[]
    overtime_application_approval_params.each do |id, item|
      if params[:user][:attendances][id][:overtime_approval_change] == "1"
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
        
        if overtime_application_approval_params[id][:instructor_confirmation_status] == "なし"
          attendance.update(scheduled_end_time: nil, office_work_contents: nil, instructor_confirmation_stamp: nil,instructor_confirmation_status: nil)        
        end
      end
    end
    redirect_to @user
  end


  
  private
    # 1か月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end

    def attendances_change_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end

    def overtime_application_params
      params.require(:user).permit(attendances: [:scheduled_end_time, :next_day, :office_work_contents, :instructor_confirmation_stamp, :instructor_confirmation_status,])[:attendances]
    end

    def overtime_application_approval_params
      params.require(:user).permit(attendances: [:scheduled_end_time, :next_day, :office_work_contents, :instructor_confirmation_stamp, :instructor_confirmation_status,
      :overtime_approval_change])[:attendances]
    end
    
    def attendances_application_params
      #debugger
      params.require(:attendance).permit( [:month_attendances_approval_stamp,:month_attendances_approval_status])
      #params.require(:user).permit(attendances: [:month_attendances_approval_stamp,:month_attendances_approval_status])[:attendances]
      #debugger
    end
        
    def update_attendances_application_params
      params.require(:user).permit(attendances: [:month_attendances_approval_change,:month_attendances_approval_status])[:attendances]
      #debugger
    end

    def update_attendances_change_params
      #debugger
      params.require(:user).permit(attendances: [:change_application_started_time,:change_application_finished_time,
      :change_application_stamp,
      :change_application_next_day,
      :change_application_note,])[:attendances]
      #debugger
    end

    def update_attendances_change_apploval_params
      params.require(:user).permit(attendances: 
      [:change_application_status,
      :change_application_change,
      ])[:attendances]
      #debugger
    end
    # 管理権限者、または現在ログインしているユーザーを許可します。
    def admin_or_correct_user
      @user = User.find(params[:user_id]) if @user.blank?
      unless current_user?(@user) || current_user.admin?
        flash[:danber] ="編集権限がありません"
        redirect_to(root_url)
      end
    end
end
