class AddLastPostDenormalization < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :last_post_remote_created_at, :timestamp, precision: 6
    add_column :topics, :last_post_remote_id, :bigint, index: true
    add_foreign_key :topics, :posts, column: :last_post_remote_id, primary_key: :remote_id
    add_index :topics, :last_post_remote_created_at
  end
end
