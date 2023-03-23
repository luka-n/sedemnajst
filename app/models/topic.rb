class Topic < ApplicationRecord
  belongs_to :forum
  belongs_to :user

  has_many :posts

  has_one :last_post,
          class_name: "Post",
          primary_key: :last_post_remote_id,
          foreign_key: :remote_id

  trigger.after(:insert) do
    "UPDATE users SET topics_count = topics_count + 1 WHERE id = NEW.user_id"
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
end
