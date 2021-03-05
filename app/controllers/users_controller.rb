class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info ]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only:[:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only:[:show]
  
  def index
    @users = User.paginate(page: params[:page])
    
    @users = @users.where('name LIKE ?', "%#{params[:sword]}%") if params[:sword].present?
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
        params.require(:user).permit(:basic_time, :work_time)
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
        if current_user.admin?
        else
          redirect_to(root_url) unless current_user?(@user)
        end
      end
      
      def admin_user
        redirect_to root_url unless current_user.admin?
      end
end
