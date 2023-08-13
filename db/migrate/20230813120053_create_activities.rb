class CreateActivities < ActiveRecord::Migration[7.0]
  def up
    create_table :activities do |t|
      t.text :content, null: false

      t.belongs_to :source, index: true, null: false, polymorphic: true
      t.belongs_to :user, foreign_key: true, index: true, null: false

      t.timestamps null: false
    end

    execute <<-SQL
      CREATE INDEX tsvector_index_activities_on_content
        ON activities USING GIN (to_tsvector('simple', coalesce(content, ''::text)));
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX tsvector_index_activities_on_content;
    SQL
  end
end
