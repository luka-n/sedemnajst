module Mn3njalnik
  class Forum
    attr_reader :attrs

    def initialize(connection, attrs)
      @connection, @attrs = connection, attrs
      @agent = @connection.agent
    end

    def topics
      topics = []
      url = @attrs[:url]

      loop do
        page = @agent.get(url)

        page.search(".cTopicList > li > .ipsDataItem_main").each do |topic_row|
          link = topic_row.search("h4 > span > a")[0]
          user_link = topic_row.search(".ipsDataItem_meta > span > a")[0]
          time = topic_row.search(".ipsDataItem_meta > time")[0]

          id = link.attr(:href).split("/")[-1].split("-")[0].to_i
          title = link.attr(:title)
          url = link.attr(:href)
          user_id = user_link.attr(:href).split("/")[-1].split("-")[0].to_i
          user_name = user_link.attr(:title)[16..]
          created_at = Time.zone.iso8601(time.attr(:datetime))

          topics << Topic.new(
            @connection,
            forum_id: @attrs[:id],
            id: id,
            title: title,
            url: url,
            user_id: user_id,
            user_name: user_name,
            created_at: created_at
          )
        end

        next_page_link =
          page.search("[data-tableid=topics] li:not(.ipsPagination_inactive) a[rel=next]")[0]

        break unless next_page_link

        url = next_page_link.attr(:href)
      end

      topics
    end
  end
end
