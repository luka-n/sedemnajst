# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_13_121723) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "activities", force: :cascade do |t|
    t.text "content", null: false
    t.string "source_type", null: false
    t.bigint "source_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('simple'::regconfig, COALESCE(content, ''::text))", name: "tsvector_index_activities_on_content", using: :gin
    t.index ["source_type", "source_id"], name: "index_activities_on_source"
    t.index ["user_id"], name: "index_activities_on_user_id"
  end

  create_table "chatrooms", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "remote_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remote_id"], name: "index_chatrooms_on_remote_id", unique: true
  end

  create_table "forums", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "remote_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remote_id"], name: "index_forums_on_remote_id", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chatroom_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.datetime "remote_created_at", null: false
    t.bigint "remote_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('simple'::regconfig, COALESCE(content, ''::text))", name: "tsvector_index_messages_on_content", using: :gin
    t.index ["chatroom_id"], name: "index_messages_on_chatroom_id"
    t.index ["remote_created_at"], name: "index_messages_on_remote_created_at"
    t.index ["remote_id"], name: "index_messages_on_remote_id", unique: true
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "topic_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.datetime "remote_created_at", null: false
    t.bigint "remote_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "to_tsvector('simple'::regconfig, COALESCE(content, ''::text))", name: "tsvector_index_posts_on_content", using: :gin
    t.index ["remote_id"], name: "index_posts_on_remote_id", unique: true
    t.index ["topic_id"], name: "index_posts_on_topic_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.bigint "forum_id", null: false
    t.bigint "user_id", null: false
    t.string "title", null: false
    t.datetime "remote_created_at", null: false
    t.bigint "remote_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "posts_count", default: 0, null: false
    t.datetime "last_post_remote_created_at"
    t.bigint "last_post_remote_id"
    t.index ["forum_id"], name: "index_topics_on_forum_id"
    t.index ["last_post_remote_created_at"], name: "index_topics_on_last_post_remote_created_at"
    t.index ["posts_count"], name: "index_topics_on_posts_count"
    t.index ["remote_id"], name: "index_topics_on_remote_id", unique: true
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "remote_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "messages_count", default: 0, null: false
    t.integer "posts_count", default: 0, null: false
    t.integer "topics_count", default: 0, null: false
    t.string "password_digest"
    t.index ["messages_count"], name: "index_users_on_messages_count"
    t.index ["name"], name: "index_users_on_name"
    t.index ["posts_count"], name: "index_users_on_posts_count"
    t.index ["remote_id"], name: "index_users_on_remote_id", unique: true
    t.index ["topics_count"], name: "index_users_on_topics_count"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activities", "users"
  add_foreign_key "messages", "chatrooms"
  add_foreign_key "messages", "users"
  add_foreign_key "posts", "topics"
  add_foreign_key "posts", "users"
  add_foreign_key "topics", "forums"
  add_foreign_key "topics", "posts", column: "last_post_remote_id", primary_key: "remote_id"
  add_foreign_key "topics", "users"
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
