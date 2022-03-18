class CreateMessageUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :message_users do |t|
      t.references :user, null: false, foreign_key: {to_table: :users}
      t.references :opposite_user, null: false, foreign_key: {to_table: :users}
      t.boolean :is_delete, null: false
      t.datetime :created_at, null: false
    end
  end
end
