class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: {to_table: :users}, index: false
      t.references :post, null: false, foreign_key: {to_table: :posts}, index: false
      t.datetime :created_at, null: false
    end

    add_index :likes, [:user_id, :post_id], unique: true
  end
end
