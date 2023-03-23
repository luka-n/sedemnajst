# This migration was auto-generated via `rake db:generate_trigger_migration'.
# While you can edit this file, any changes you make to the definitions here
# will be undone by the next auto-generated trigger migration.

class CreateTriggersMultipleTables < ActiveRecord::Migration[7.0]
  def up
    create_trigger("topics_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        after(:insert) do
      "UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;"
    end

    create_trigger("topics_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        after(:delete) do
      "UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id;"
    end

    create_trigger("topics_after_update_row_tr", :generated => true, :compatibility => 1).
        on("topics").
        after(:update) do
      <<-SQL_ACTIONS
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;
      END IF;
      SQL_ACTIONS
    end

    create_trigger("posts_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        after(:insert) do
      <<-SQL_ACTIONS
      UPDATE topics SET posts_count = posts_count + 1 WHERE id = NEW.topic_id;
      UPDATE topics SET last_post_remote_created_at = NEW.remote_created_at,
                        last_post_remote_id = NEW.remote_id
      WHERE id = NEW.topic_id;
      UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
      SQL_ACTIONS
    end

    create_trigger("posts_after_update_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        after(:update) do
      <<-SQL_ACTIONS
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET posts_count = posts_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
      END IF;
      SQL_ACTIONS
    end

    create_trigger("posts_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("posts").
        after(:delete) do
      <<-SQL_ACTIONS
      UPDATE users SET posts_count = posts_count - 1 WHERE id = OLD.user_id;
      UPDATE topics SET posts_count = posts_count - 1 WHERE id = OLD.topic_id;
      IF (OLD.remote_id IS NOT NULL AND OLD.remote_id =
          (SELECT last_post_remote_id FROM topics WHERE id = OLD.topic_id)) OR
           OLD.remote_created_at =
            (SELECT last_post_remote_created_at
             FROM topics WHERE id = OLD.topic_id) THEN
        UPDATE topics
        SET last_post_remote_created_at = last_posts.remote_created_at,
            last_post_remote_id = last_posts.remote_id
        FROM (
          SELECT max(remote_created_at) AS remote_created_at,
                 max(remote_id) AS remote_id
          FROM posts
          WHERE topic_id = OLD.topic_id
        ) AS last_posts
        WHERE id = OLD.topic_id;
      END IF;
      SQL_ACTIONS
    end

    create_trigger("messages_after_insert_row_tr", :generated => true, :compatibility => 1).
        on("messages").
        after(:insert) do
      "      UPDATE users SET messages_count = messages_count + 1 WHERE id = NEW.user_id;"
    end

    create_trigger("messages_after_update_row_tr", :generated => true, :compatibility => 1).
        on("messages").
        after(:update) do
      <<-SQL_ACTIONS
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET messages_count = messages_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET messages_count = messages_count + 1 WHERE id = NEW.user_id;
      END IF;
      SQL_ACTIONS
    end

    create_trigger("messages_after_delete_row_tr", :generated => true, :compatibility => 1).
        on("messages").
        after(:delete) do
      "      UPDATE users SET messages_count = messages_count - 1 WHERE id = OLD.user_id;"
    end
  end

  def down
    drop_trigger("topics_after_insert_row_tr", "topics", :generated => true)

    drop_trigger("topics_after_delete_row_tr", "topics", :generated => true)

    drop_trigger("topics_after_update_row_tr", "topics", :generated => true)

    drop_trigger("posts_after_insert_row_tr", "posts", :generated => true)

    drop_trigger("posts_after_update_row_tr", "posts", :generated => true)

    drop_trigger("posts_after_delete_row_tr", "posts", :generated => true)

    drop_trigger("messages_after_insert_row_tr", "messages", :generated => true)

    drop_trigger("messages_after_update_row_tr", "messages", :generated => true)

    drop_trigger("messages_after_delete_row_tr", "messages", :generated => true)
  end
end
