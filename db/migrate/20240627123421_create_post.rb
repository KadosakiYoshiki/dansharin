class CreatePost < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.text :content, null: false
      t.timestamps
    end
  end
end
