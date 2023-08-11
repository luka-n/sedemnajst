class IndexRemoteCreatedAtOnMessages < ActiveRecord::Migration[7.0]
  def change
    add_index :messages, :remote_created_at
  end
end
