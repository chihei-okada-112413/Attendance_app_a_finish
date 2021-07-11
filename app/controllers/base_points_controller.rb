class BasePointsController < ApplicationController
  before_action :set_base_point, only: [:destroy, :update, :edit]
  before_action :admin_user, only:[:destroy, :index, :new, :edit, ]

  def index
    
    @base_points = BasePoint.all
  end

  def new
    @base_point = BasePoint.new
  end

  def create
    @base_point = BasePoint.new(base_point_params)
    if @base_point.save
      flash[:success] ="拠点情報を追加しました。"
    else
      flash[:denger] ="拠点情報の追加に失敗しました。"
    end
      redirect_to base_points_url
  end

  def edit
    
  end

  def update
    if @base_point.update_attributes(base_point_params)
      flash[:success] ="拠点情報を更新しました。"
    else
      flash[:denger] ="拠点情報の更新に失敗しました。"
    end
    redirect_to base_points_url
  end

  def destroy
    if @base_point.destroy
    flash[:success] = "拠点情報を削除しました。"
    else
    flash[:danger] = "拠点情報の削除に失敗しました。"
    end
    redirect_to base_points_url
  end

  private
  def set_base_point
    @base_point = BasePoint.find(params[:id])
  end

  def base_point_params
    params.require(:base_point).permit(:base_point_name, :base_point_number, :base_point_type)
  end

end
