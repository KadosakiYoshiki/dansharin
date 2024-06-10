class UsersController < ActionController::Base
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :accessble_user?, only: [:edit, :update, :destroy]

  def index
    
  end

  def show

  end

  def edit

  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Profile image was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to root_url, notice: 'ご利用ありがとうございました。'
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
    params.require(:user).permit(:profile_image, :name, :nickname, :username)
  end
end
