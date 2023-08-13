# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersTopicsInsertOrPostsInsertOrMessagesInsert1 < ActiveRecord::Migration[7.0]
  def up
    drop_trigger("topics_after_insert_row_tr", "topics", :generated => true)

    drop_trigger("posts_after_insert_row_tr", "posts", :generated => true)

    drop_trigger("messages_after_insert_row_tr", "messages", :generated => true)

    create_trigger("topics_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        after(:insert) do
      <<-SQL_ACTIONS
      INSERT INTO activities
        (content, created_at, remote_created_at, source_id, source_type, updated_at, user_id)
        VALUES
        (NEW.title, now(), NEW.remote_created_at, NEW.id, 'Topic', now(), NEW.user_id);

      UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;
      SQL_ACTIONS
    end

    create_trigger("posts_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        after(:insert) do
      <<-SQL_ACTIONS
      INSERT INTO activities
        (content, created_at, remote_created_at, source_id, source_type, updated_at, user_id)
        VALUES
        (NEW.content, now(), NEW.remote_created_at, NEW.id, 'Post', now(), NEW.user_id);

      UPDATE topics SET posts_count = posts_count + 1 WHERE id = NEW.topic_id;
      UPDATE topics SET last_post_remote_created_at = NEW.remote_created_at,
                        last_post_remote_id = NEW.remote_id
      WHERE id = NEW.topic_id;
      UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
      SQL_ACTIONS
    end

    create_trigger("messages_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("messages").
        after(:insert) do
      <<-SQL_ACTIONS
      INSERT INTO activities
        (content, created_at, remote_created_at, source_id, source_type, updated_at, user_id)
        VALUES
        (NEW.content, now(), NEW.remote_created_at, NEW.id, 'Message', now(), NEW.user_id);

      UPDATE users SET messages_count = messages_count + 1 WHERE id = NEW.user_id;
      SQL_ACTIONS
    end
  end

  def down
    drop_trigger("topics_after_insert_row_tr", "topics", :generated => true)

    drop_trigger("posts_after_insert_row_tr", "posts", :generated => true)

    drop_trigger("messages_after_insert_row_tr", "messages", :generated => true)

    create_trigger("topics_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        after(:insert) do
      <<-SQL_ACTIONS
      INSERT INTO activities (content, source_type, source_id, user_id, created_at, updated_at)
        VALUES (NEW.title, 'Topic', NEW.id, NEW.user_id, now(), now());

      UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;
      SQL_ACTIONS
    end

    create_trigger("posts_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        after(:insert) do
      <<-SQL_ACTIONS
      INSERT INTO activities (content, source_type, source_id, user_id, created_at, updated_at)
        VALUES (NEW.content, 'Post', NEW.id, NEW.user_id, now(), now());

      UPDATE topics SET posts_count = posts_count + 1 WHERE id = NEW.topic_id;
      UPDATE topics SET last_post_remote_created_at = NEW.remote_created_at,
                        last_post_remote_id = NEW.remote_id
      WHERE id = NEW.topic_id;
      UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
      SQL_ACTIONS
    end

    create_trigger("messages_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("messages").
        after(:insert) do
      <<-SQL_ACTIONS
      INSERT INTO activities (content, source_type, source_id, user_id, created_at, updated_at)
        VALUES (NEW.content, 'Message', NEW.id, NEW.user_id, now(), now());
      UPDATE users SET messages_count = messages_count + 1 WHERE id = NEW.user_id;
      SQL_ACTIONS
    end
  end
end
