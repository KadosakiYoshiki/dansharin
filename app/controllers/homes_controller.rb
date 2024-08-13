class HomesController < ApplicationController
  def index
    @posts = Post.joins(:user).where(replied_id: nil).order(created_at: :desc)
  end
end
