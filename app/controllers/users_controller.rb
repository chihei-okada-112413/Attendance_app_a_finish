class UsersController < ApplicationController
  def new
    @user = User.new #ユーザーオブジェクトを生成し、インスタンス変数に代入。
  end
  
  def show
    @user = User.find(params[:id])
    #debugger # インスタンス変数を定義した直後にこのメソッドが実行されます。
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] ="新規作成に成功しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  private
      def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end
end
