class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.belongs_to :topic, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.text :content, null: false
      t.timestamp :posted_at, null: false, precision: 6

      t.bigint :remote_id, index: {unique: true}, null: false

      t.timestamps null: false
    end
  end
end
