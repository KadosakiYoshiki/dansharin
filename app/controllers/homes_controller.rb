class HomesController < ApplicationController
  def index
    @posts = Post.joins(:user).all.order(created_at: :desc)
  end
end
