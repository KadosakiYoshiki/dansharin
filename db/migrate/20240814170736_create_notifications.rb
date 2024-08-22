class CreateNotifications < ActiveRecord::Migration[7.1]
  def change
    create_table :notifications, id: :string do |t|
      t.references :user, null: false, foreign_key: true, type: :string
      t.references :notifiable, polymorphic: true, null: false, type: :string
      t.string :notification_type
      t.boolean :read, default: false, null: false

      t.timestamps
    end
  end
end
