class Post < ApplicationRecord
  include PgSearch::Model

  belongs_to :topic
  belongs_to :user

  has_one :activity, as: :source

  pg_search_scope :content_search,
                  against: :content,
                  using: {
                    tsearch: {
                      highlight: {
                        StartSel: "<span class='search-highlight'>",
                        StopSel: "</span>"
                      }
                    }
                  }

  trigger.after(:insert) do
    <<-SQL
      INSERT INTO activities
        (content, created_at, remote_created_at, source_id, source_type, updated_at, user_id)
        VALUES
        (NEW.content, now(), NEW.remote_created_at, NEW.id, 'Post', now(), NEW.user_id);

      UPDATE topics SET posts_count = posts_count + 1 WHERE id = NEW.topic_id;
      UPDATE topics SET last_post_remote_created_at = NEW.remote_created_at,
                        last_post_remote_id = NEW.remote_id
      WHERE id = NEW.topic_id;
      UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
    SQL
  end

  trigger.after(:update) do
    <<-SQL
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET posts_count = posts_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET posts_count = posts_count + 1 WHERE id = NEW.user_id;
      END IF;
    SQL
  end

  trigger.after(:delete) do
    <<-SQL
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
    SQL
  end

  class << self
    def ransackable_associations(*)
      %w[]
    end

    def ransackable_attributes(*)
      %w[remote_created_at user_id]
    end

    def ransackable_scopes(*)
      %w[content_search]
    end
  end
end
