module SessionsHelper
    
    # 引数に渡されたユーザーオブジェクトでログイン。
    def log_in(user)
       session[:user_id] = user.id 
    end
    
    def log_out
        session.delete(:user_id)
        @current_user = nil
    end
#   def current_user
#       if session[:user_id]
#           if @current_user.nil?
#               @current_user = User.find_by(id: session[user_id])
#         　else
#           @current_user
#           end
#       end
#   end ↓ 省略形
    def current_user
        if session[:user_id]
            @current_user = @current_user || User.find_by(id: session[:user_id])
        end
    end
    # 現在ログイン中のユーザーがいればtrue、そうでなければfalseを返します。
    def logged_in?
        !current_user.nil?
    end
end
