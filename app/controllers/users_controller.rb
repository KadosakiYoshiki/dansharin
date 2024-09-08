class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show, :edit, :update, :destroy]
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
      flash[:notice] = "更新しました"
      redirect_to @user
    else
      render turbo_stream: turbo_stream.update("post_error_messages", partial: "shared/error_messages", locals: { object: @user })
    end
  end

  def destroy
    redirect_to root_url and return unless current_user == @user

    ActiveRecord::Base.transaction do
      begin
        # プロフィール画像を即座に削除
        @user.profile_image.purge
        
        # ユーザーの投稿に関連する画像をすべて削除
        @user.posts.each { |post| post.post_images.purge }
        
        # ユーザーを削除
        if @user.destroy
          flash[:notice] = "ご利用ありがとうございました。"
        else
          # ユーザー削除が失敗した場合にロールバック
          raise ActiveRecord::Rollback, "ユーザーの削除に失敗しました。"
        end
      rescue => e
        # エラーが発生した場合の処理
        flash[:alert] = "削除中にエラーが発生しました: #{e.message}"
        redirect_to edit_user_path(@user) and return
      end
    end
  
    # 正常に削除された場合、ルートURLへリダイレクト
    redirect_to root_url
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
