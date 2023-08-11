class CreateGinIndexes < ActiveRecord::Migration[7.0]
  def up
    execute <<SQL
   CREATE INDEX tsvector_index_messages_on_content
     ON messages USING GIN (to_tsvector('simple', coalesce(content, ''::text)));
   CREATE INDEX tsvector_index_posts_on_content
     ON posts USING GIN (to_tsvector('simple', coalesce(content, ''::text)));
SQL
  end

  def down
    execute <<SQL
   DROP INDEX tsvector_index_messages_on_content;
   DROP INDEX tsvector_index_posts_on_content;
SQL
  end
end
