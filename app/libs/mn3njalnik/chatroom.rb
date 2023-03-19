module Mn3njalnik
  class Chatroom
    attr_reader :attrs

    def initialize(connection, attrs)
      @connection, @attrs = connection, attrs
      @agent = @connection.agent
    end

    def messages(&block)
      last_id = 0

      catch(:done) do
        loop do
          response = @agent.post(
            Connection::BASE_URL,
            {
              app: "chatbox",
              module: "chatbox",
              controller: "room",
              id: @attrs[:id],
              do: "getMSG",

              csrfKey: @connection.csrf_key,
              lastID: last_id,
              firstLoad: last_id == 0 ? 1 : 0,
              loadMoreMode: last_id == 0 ? 0 : 1
            },
            {"X-Requested-With" => "XMLHttpRequest"}
          )

          data = JSON.parse(response.content)

          data["content"].reverse.each do |message|
            ret = block.call(
              Message.new(
                @connection,
                id: message["id"].to_i,
                user_id: message["chatterID"].to_i,
                user_name: message["chatterName"],
                content: message["content"],
                posted_at: parse_time(message["time"])
              )
            )
            throw :done unless ret
          end

          if data["noMore"] == "1"
            break
          else
            last_id = data["content"][0]["id"].to_i
          end
        end
      end
    end

    private

    def parse_time(time)
      if time =~ %r[^\d{2}/\d{2}/\d{2} \d{2}:\d{2} (AM|PM)$]
        Time.zone.strptime(time, "%d/%m/%y %I:%M %p")
      else
        Time.zone.iso8601(time)
      end
    end
  end
end
