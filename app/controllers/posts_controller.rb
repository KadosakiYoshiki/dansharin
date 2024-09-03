class PostsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_post, only: [:show, :destroy, :reaction_users]

  def new
    @post = Post.new(replied_id: params[:replied_id])
  end

  def create
    @post = Post.new(post_params)
    if (@save_flag = @post.save)
      flash[:success] = "SUCESS!"
    else
      flash[:alert] = "OOPS!"
      render turbo_stream: [ turbo_stream.replace("post_error_messages",
        partial: "shared/error_messages",
        locals: { object: @post })
      ]
    end
  end

  def show

  end

  def destroy
    @post.destroy
    flash[:success] = "SUCESS!"
    redirect_to params[:path] ||= root_url
  end

  def reaction_users
    @emoji = params[:emoji]
    @rc = @post.reaction_count(@emoji)
    @users = @post.reactions.where(emoji: @emoji).includes(:user).map(&:user)
  end

  private

  def set_post
    @post = Post.eager_load(:reactions, replies: :reactions).find_by_id(params[:id])
    redirect_to root_url unless @post
  end

  def post_params
    params.require(:post).permit(:replied_id, :content, post_images: []).merge(user_id: current_user.id)
  end
end
