require 'csv'
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:sindex, :index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info ]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only:[:destroy, :edit_basic_info, :update_basic_info, :index, :sindex]
  before_action :set_one_month, only:[:show ]
  
  def index
    @users = User.paginate(page: params[:page])
    
    @users = @users.where('name LIKE ?', "%#{params[:sword]}%") if params[:sword].present?
  end

  def sindex
    @users = User.all
    #debugger
  end

  def import
    if params[:file]
    User.import(params[:file])
    flash[:success] = "CSVをインポートしました"
    else
      flash[:danger] = "CSVを選択してください"
    end
    redirect_to users_url
  end
  
  def search_user
    @susers = params[:sword]
  end
  
  def new
    @user = User.new #ユーザーオブジェクトを生成し、インスタンス変数に代入。
  end
  
  def show

    #debugger # インスタンス変数を定義した直後にこのメソッドが実行されます。
    @worked_sum = @attendances.where.not(started_at: nil).count

    respond_to do |format|
      format.html
      format.csv do |csv|
        send_attendances_csv(@attendances)
      end
    end

    @users = User.includes(:attendances)
    #debugger
    @countjyotyo1 = Attendance.where(instructor_confirmation_status: "申請中" , instructor_confirmation_stamp: "上長1").count
    #@aaa = @users.id(params[:id])
    @countjyotyo2 = Attendance.where(instructor_confirmation_status: "申請中" , instructor_confirmation_stamp: "上長2").count
    @countapproval1 = Attendance.where(month_attendances_approval_status: "申請中" , month_attendances_approval_stamp: "上長1").distinct.count(:month)
    @countapproval2 = Attendance.where(month_attendances_approval_status: "申請中" , month_attendances_approval_stamp: "上長2").distinct.count(:month)
    @countchange1 = Attendance.where(change_application_status: "申請中" , change_application_stamp: "上長1").count
    @countchange2 = Attendance.where(change_application_status: "申請中" , change_application_stamp: "上長2").count
    #debugger
    @user_now = User.find(params[:usernow]) if params[:usernow]
    #debugger
  end

  def send_attendances_csv(attendandes)
    csv_data = CSV.generate do |csv|
      header = %w(worked_on started_at finished_at)
      csv << header

      @attendances.each do |attendance|
        unless attendance.change_application_status == "申請中"
        #debugger
          if attendance.started_at.present? && attendance.finished_at.present?
          values = [attendance.worked_on,attendance.started_at.strftime("%H:%M:%S"),attendance.finished_at.strftime("%H:%M:%S")]
          csv << values
          end
        end
      end

    end
    send_data(csv_data, filename: "attendances.csv")
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user #保存成功後、ログインする。
      flash[:success] ="新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
      if @user.update_attributes(user_params)
        flash[:success] = "ユーザー情報を更新しました。"
        redirect_to @user
      else
        render :edit
      end
  end
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end
  
  def edit_basic_info
    # debugger
  end

  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end
  
  private
      def user_params
        params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
      end
      
      def basic_info_params
        params.require(:user).permit(:basic_time, :work_time, :name, :email, :affiliation, :employee_number, :uid, :password, :basic_work_time, :designated_work_start_time, :designated_work_end_time)
      end
      
      # beforeフィルター
      
      # paramsハッシュからユーザーを取得する。
      def set_user
        @user = User.find(params[:id])
      end
      
      def set_user_
        @user = User.find(params[:user_id])
      end
      
      # ログイン済みのユーザーか確認する
      def logged_in_user
        unless logged_in?
          store_location
          flash[:danger] = "ログインしてください。"
          redirect_to login_url
        end
      end
      
      # アクセスしたユーザーが現在ログインしているユーザーか調べる
      def correct_user
        #debugger
        if current_user.admin? || current_user.superior?
        else
          redirect_to(root_url) unless current_user?(@user)
        end
      end
      
      def admin_user
        redirect_to root_url unless current_user.admin?
      end
end
