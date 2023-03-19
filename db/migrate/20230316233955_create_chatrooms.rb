class CreateChatrooms < ActiveRecord::Migration[7.0]
  def change
    create_table :chatrooms do |t|
      t.string :name, null: false
      t.bigint :remote_id, index: {unique: true}, null: false

      t.timestamps null: false
    end
  end
end
