class ChangeColumnNameForMessageContentsOfPosts < ActiveRecord::Migration[6.1]
  def change
    rename_column :posts, :message_contents, :post_contents
  end
end
