module Mn3njalnik
  class User
    attr_reader :attrs

    def initialize(connection, attrs)
      @connection, @attrs = connection, attrs
      @agent = @connection.agent
    end

    def download_avatar
      return nil unless attrs[:avatar_url]
      tmp_file = Tempfile.new
      @agent.download(attrs[:avatar_url], tmp_file.path)
      tmp_file
    rescue Mechanize::ResponseCodeError => e
      if e.response_code == "404"
        return nil
      else
        raise e
      end
    end
  end
end
