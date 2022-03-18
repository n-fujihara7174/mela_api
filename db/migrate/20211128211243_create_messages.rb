class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :sender_user, null: false, foreign_key: {to_table: :users}
      t.string :message_contents, null: false, limit: 240
      t.text :message_image
      t.references :receiver_user, null: false, foreign_key: {to_table: :users}
      t.boolean :is_delete, null: false
      t.datetime :created_at, null: false
    end
  end
end
