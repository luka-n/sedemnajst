class AddCounters < ActiveRecord::Migration[7.0]
  def change
    add_column :topics, :posts_count, :integer, default: 0, null: false
    add_column :users, :messages_count, :integer, default: 0, null: false
    add_column :users, :posts_count, :integer, default: 0, null: false
    add_column :users, :topics_count, :integer, default: 0, null: false
  end
end
