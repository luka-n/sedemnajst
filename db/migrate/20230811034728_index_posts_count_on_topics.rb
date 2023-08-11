class IndexPostsCountOnTopics < ActiveRecord::Migration[7.0]
  def change
    add_index :topics, :posts_count
  end
end
