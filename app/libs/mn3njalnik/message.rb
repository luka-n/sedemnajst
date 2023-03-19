module Mn3njalnik
  class Message
    attr_reader :attrs

    def initialize(connection, attrs)
      @connection, @attrs = connection, attrs
      @agent = @connection.agent
    end
  end
end
