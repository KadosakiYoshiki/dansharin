class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :accessble_user?, only: [:edit, :update, :destroy]

  def show
    @posts = @user.posts.order(created_at: :desc).page(params[:page])
  end

  def edit
    redirect_to root_url and return unless current_user == @user
    @post_create = false
  end

  def update
    redirect_to root_url and return unless current_user == @user
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile image was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    redirect_to root_url and return unless current_user == @user
    @user.destroy
    redirect_to root_url, notice: 'ご利用ありがとうございました。'
  end

  def search
    if current_user.username == params[:username]
      render json: { message: "OK", valid: true }
    else
      @user = User.find_by_username(params[:username])
      if @user.present?
        render json: { message: "そのユーザIDは既に使用されています。", valid: false }
      else
        render json: { message: "OK", valid: true }
      end
    end
  end

  private

  def set_user
    @user = User.find_by_username(params[:username])
    redirect_to root_url unless @user
  end

  def accessble_user?
    redirect_to root_url if @user != current_user
  end

  def user_params
    params.require(:user).permit(:profile_image, :nickname, :username, :description)
  end
end
