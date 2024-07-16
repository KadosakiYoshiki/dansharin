class PostsController < ApplicationController
  before_action :set_post, only: [:show, :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "SUCESS!"
      redirect_to params[:path] ||= root_url
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

  private

  def set_post
    @post = Post.find_by_id(params[:id])
    redirect_to root_url unless @post
  end

  def post_params
    params.require(:post).permit(:content, post_images: []).merge(user_id: current_user.id)
  end
end
