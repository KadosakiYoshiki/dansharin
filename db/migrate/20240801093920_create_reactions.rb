class CreateReactions < ActiveRecord::Migration[7.1]
  def change
    create_table :reactions, id: :string do |t|
      t.references :post, null: false, foreign_key: true, type: :string
      t.references :user, null: false, foreign_key: true, type: :string
      t.string :emoji, null: false

      t.timestamps
    end

    add_index :reactions, [:post_id, :user_id, :emoji], unique: true
  end
end
