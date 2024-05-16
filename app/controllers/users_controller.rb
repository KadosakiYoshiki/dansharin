class UsersController < ActionController::Base
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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

  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:profile_image, :name, :nickname)
  end
end
