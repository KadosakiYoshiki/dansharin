class ReactionsController < ApplicationController
  before_action :set_post, only: [:create, :destroy]

  def create
    @reaction = @post.reactions.new(reaction_params)
    @reaction.save
    render turbo_stream: [
      turbo_stream.update("reactions_post_#{@post.id}", partial: "reactions/reactions", locals: { post: @post }),
      turbo_stream.update("reactions_detail_post_#{@post.id}", partial: "reactions/reactions_detail", locals: { post: @post })
    ]
  end

  def destroy
    reaction = @post.reactions.find_by_id(params[:id])
    reaction&.destroy
    render turbo_stream: [
      turbo_stream.update("reactions_post_#{@post.id}", partial: "reactions/reactions", locals: { post: @post }),
      turbo_stream.update("reactions_detail_post_#{@post.id}", partial: "reactions/reactions_detail", locals: { post: @post })
    ]
  end

  private

  def set_post
    @post = Post.find_by_id(params[:post_id])
    redirect_to root_url unless @post
  end

  def reaction_params
    params.require(:reaction).permit(:emoji).merge(user_id: current_user.id)
  end
end
