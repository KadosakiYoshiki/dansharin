class ImagesController < ApplicationController
  def show
    @image = Post.find_by_id(params[:post_id]).post_images.find_by(blob_id: params[:id])
  end
end
