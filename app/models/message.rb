class Message < ApplicationRecord
  belongs_to :chatroom
  belongs_to :user

  trigger.after(:insert) do
    <<-SQL
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
end
