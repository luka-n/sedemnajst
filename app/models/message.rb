class Message < ApplicationRecord
  include PgSearch::Model

  belongs_to :chatroom
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
        (NEW.content, now(), NEW.remote_created_at, NEW.id, 'Message', now(), NEW.user_id);

      UPDATE users SET messages_count = messages_count + 1 WHERE id = NEW.user_id;
    SQL
  end

  trigger.after(:update) do
    <<-SQL
      IF NEW.user_id != OLD.user_id THEN
        UPDATE users SET messages_count = messages_count - 1 WHERE id = OLD.user_id;
        UPDATE users SET messages_count = messages_count + 1 WHERE id = NEW.user_id;
      END IF;
    SQL
  end

  trigger.after(:delete) do
    <<-SQL
      UPDATE users SET messages_count = messages_count - 1 WHERE id = OLD.user_id;
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
