class HomesController < ApplicationController
  def index
    @posts = Post.joins(:user).order(created_at: :desc)
  end
end
