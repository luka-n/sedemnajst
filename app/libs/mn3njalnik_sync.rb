class Mn3njalnikSync
  def initialize
    @cnx = Mn3njalnik::Connection.new
    @cnx.login(
      Rails.configuration.mn3njalnik.username,
      Rails.configuration.mn3njalnik.password
    )
  end

  def sync
    sync_forums
    sync_chatrooms
  end

  def sync_forums
    @cnx.forums.each do |remote_forum|
      Forum.find_or_create_by!(remote_id: remote_forum.attrs[:id]) do |local_forum|
        local_forum.name = remote_forum.attrs[:name]
      end

      if Rails.configuration.mn3njalnik.forums_to_sync.include?(remote_forum.attrs[:id])
        remote_forum.topics.each do |remote_topic|
          sync_topic(remote_topic)
        end
      end
    end
  end

  def sync_chatrooms
    Rails.configuration.mn3njalnik.chatrooms_to_sync.each do |remote_id|
      local_chatroom = Chatroom.find_by_remote_id!(remote_id)
      last_message_id = local_chatroom.messages.maximum(:remote_id) || 0
      @cnx.get_chatroom(remote_id).messages do |remote_message|
        if remote_message.attrs[:id] <= last_message_id
          false
        else
          local_user =
            User.find_or_create_by!(remote_id: remote_message.attrs[:user_id]) do |local_user|
              local_user.name = remote_message.attrs[:user_name]
            end
          local_chatroom.messages.create!(
            remote_id: remote_message.attrs[:id],
            user_id: local_user.id,
            content: remote_message.attrs[:content],
            posted_at: remote_message.attrs[:posted_at]
          )
        end
      end
    end
  end

  def sync_topic(remote_topic)
    local_forum = Forum.find_by_remote_id!(remote_topic.attrs[:forum_id])

    local_user = User.find_or_create_by!(remote_id: remote_topic.attrs[:user_id]) do |local_user|
      local_user.name = remote_topic.attrs[:user_name]
    end

    local_topic = Topic.find_or_create_by!(remote_id: remote_topic.attrs[:id]) do |local_topic|
      local_topic.forum = local_forum
      local_topic.user = local_user

      local_topic.posted_at = remote_topic.attrs[:posted_at]
      local_topic.title = remote_topic.attrs[:title]
    end

    remote_topic.posts.each do |remote_post|
      local_user = User.find_or_create_by!(remote_id: remote_post.attrs[:user_id]) do |local_user|
        local_user.name = remote_post.attrs[:user_name]
      end

      local_topic.posts.find_or_create_by!(remote_id: remote_post.attrs[:id]) do |local_post|
        local_post.user = local_user

        local_post.content = remote_post.attrs[:content]
        local_post.posted_at = remote_post.attrs[:posted_at]
      end
    end
  end
end
