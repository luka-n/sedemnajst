class AddIndexesOnUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :name
    add_index :users, :messages_count
    add_index :users, :posts_count
    add_index :users, :topics_count
  end
end
