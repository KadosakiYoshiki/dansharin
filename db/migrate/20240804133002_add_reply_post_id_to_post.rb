class AddReplyPostIdToPost < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :replied_id, :string
  end
end
