module Mn3njalnik
  class Post
    attr_reader :attrs

    def initialize(connection, attrs)
      @connection, @attrs = connection, attrs
      @agent = @connection.agent
    end
  end
end
