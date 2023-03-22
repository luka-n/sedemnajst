class RenamePostedAtToRemoteCreatedAt < ActiveRecord::Migration[7.0]
  def change
    rename_column :messages, :posted_at, :remote_created_at
    rename_column :posts, :posted_at, :remote_created_at
    rename_column :topics, :posted_at, :remote_created_at
  end
end
