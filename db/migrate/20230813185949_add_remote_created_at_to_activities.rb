class AddRemoteCreatedAtToActivities < ActiveRecord::Migration[7.0]
  def change
    add_column :activities,
               :remote_created_at,
               :timestamp,
               null: false,
               precision: 6

    add_index :activities, :remote_created_at
  end
end
