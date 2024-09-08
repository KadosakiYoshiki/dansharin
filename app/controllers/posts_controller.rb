class PostsController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :set_post, only: [:show, :destroy, :reaction_users]

  def new
    @post = Post.new(replied_id: params[:replied_id])
  end

  def create
    @post = Post.new(post_params)
    @save_flag = @post.save
  end

  def show

  end

  def destroy

  end

  def reaction_users
    @emoji = params[:emoji]
    @rc = @post.reaction_count(@emoji)
    @pagy, @users = pagy(User.joins(:reactions).where(reactions: { post_id: @post.id, emoji: @emoji }).order(created_at: :desc), page: params[:page])
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
