class CreateFollows < ActiveRecord::Migration[6.1]
  def change
    create_table :follows do |t|
      t.references :follow_user, null: false, foreign_key: {to_table: :users}, index: false
      t.references :follower_user, null: false, foreign_key: {to_table: :users}, index: false
      t.datetime :created_at, null: false
    end

    add_index :follows, [:follow_user_id, :follower_user_id], unique: true
  end
end
