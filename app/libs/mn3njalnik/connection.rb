module Mn3njalnik
  class Connection
    attr_reader :agent, :csrf_key

    BASE_URL = "https://mn3njalnik.com"
    LOGIN_URL = "#{BASE_URL}/index.php?/login/"
    LOGIN_FORM_ACTION_URL = "#{BASE_URL}/index.php?/login/"

    def initialize
      @agent = Mechanize.new
    end

    def login(username, password)
      @agent.get(LOGIN_URL) do |page|
        page.form_with(action: LOGIN_FORM_ACTION_URL) do |form|
          form.add_field!("_processLogin", "usernamepassword")

          form.auth = username
          form.password = password

          form._processLogin = "usernamepassword"
        end.submit

        @csrf_key =
          @agent.page.css("li[data-menuitem=signout] > a")[0]["href"]
            .match(/&csrfKey=([a-z0-9]*)/)[1]
      end
    end

    def forums
      page = @agent.get(BASE_URL)
      page
        .search(".cForumList > li > ol > .cForumRow > .ipsDataItem_main a")
        .map do |a|
          id = a.attr("href").split("/")[-1].split("-")[0].to_i
          name = a.text
          url = a.attr("href")

          Forum.new(
            self,
            id: id,
            name: name,
            url: url
          )
        end
    end

    def get_chatroom(remote_id)
      Chatroom.new(self, id: remote_id)
    end
  end
end
