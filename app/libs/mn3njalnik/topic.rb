module Mn3njalnik
  class Topic
    attr_reader :attrs

    def initialize(connection, attrs)
      @connection, @attrs = connection, attrs
      @agent = @connection.agent
    end

    def posts
      posts = []
      url = @attrs[:url]

      loop do
        page = @agent.get(url)

        page.search(".cPost").each do |post_row|
          time = post_row.search(".ipsComment_meta time")[0]
          link = time.parent
          user_link = post_row.search(".cAuthorPane_author a")[0]

          id = link.attr(:href).match(/&comment=(\d+)/)[1].to_i
          content = post_row.search("[data-role=commentContent]")[0].children.map(&:to_html).join
          user_id = user_link.attr(:href).split("/")[-1].split("-")[0].to_i
          user_name = user_link.attr(:title)[16..]
          posted_at = Time.zone.iso8601(time.attr("datetime"))

          posts << Post.new(
            @connection,
            topic_id: @attrs[:id],
            id: id,
            content: content,
            user_id: user_id,
            user_name: user_name,
            posted_at: posted_at
          )
        end

        next_page_link =
          page.search(".cTopic li:not(.ipsPagination_inactive) a[rel=next]")[0]

        if next_page_link
          url = next_page_link.attr(:href)
        else
          break
        end
      end

      posts
    end
  end
end
