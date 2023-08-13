class Topic < ApplicationRecord
  include PgSearch::Model

  belongs_to :forum
  belongs_to :user

  has_one :activity, as: :source

  has_many :posts

  has_one :last_post,
          class_name: "Post",
          primary_key: :last_post_remote_id,
          foreign_key: :remote_id

  pg_search_scope :title_search,
                  against: :title,
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
      INSERT INTO activities (content, source_type, source_id, user_id, created_at, updated_at)
        VALUES (NEW.title, 'Topic', NEW.id, NEW.user_id, now(), now());

      UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;
    SQL
  end

  trigger.after(:delete) do
    "UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id"
  end

  trigger.after(:update) do
    <<-SQL
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET topics_count = topics_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id;
      END IF;
    SQL
  end

  class << self
    def ransackable_associations(*)
      %w[]
    end

    def ransackable_attributes(*)
      %w[last_post_remote_created_at posts_count remote_created_at title user_id]
    end

    def ransackable_scopes(*)
      %w[title_search]
    end
  end
end
