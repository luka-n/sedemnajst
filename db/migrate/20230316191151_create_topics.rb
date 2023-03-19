class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics do |t|
      t.belongs_to :forum, foreign_key: true, null: false
      t.belongs_to :user, foreign_key: true, null: false

      t.string :title, null: false
      t.timestamp :posted_at, null: false, precision: 6

      t.bigint :remote_id, index: {unique: true}, null: false

      t.timestamps null: false
    end
  end
end
