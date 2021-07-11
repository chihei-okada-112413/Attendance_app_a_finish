class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  $days_of_the_week = %w{日 月 火 水 木 金 土}
  
  #@countapproval = Attendance.where(month_attendances_approval_status: "申請中").distinct.count(:month)
  #debugger
  # beforeフィルター
      
      # paramsハッシュからユーザーを取得する。
      def set_user
        @user = User.find(params[:id])
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
        redirect_to(root_url) unless current_user?(@user)
      end
      
      def admin_user
        unless current_user.admin?
          flash[:danger] = "権限がないため表示できません。"
          redirect_to root_url
        end
      end
      
  # ページ出力前に１か月分のレコードを検索し取得。
  def set_one_month
    @first_day = params[:date].nil? ?
    Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    one_month = [*@first_day..@last_day] # 対象の月の日数を代入。
    @one_month = [*@first_day..@last_day]
    # ユーザーに紐づく一か月分のレコードを検索し取得。
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    #debugger

    unless one_month.count == @attendances.count # それぞれの件数（日数）が一致するか評価します。
      ActiveRecord::Base.transaction do # トランザクションを開始します。
      # 繰り返し処理により、１か月分の勤怠データを生成します。
      one_month.each { |day| @user.attendances.create!(worked_on: day)}
    end
    @attendances = @user.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    debugger
    end
    
  rescue ActiveRecord::RecordInvalid # トランザクションによるエラーの分岐です。
    flash[:danger] = "ページ情報の取得に失敗しました。再アクセスしてください。"
    redirect_to root_url
  end
end
