module ApplicationHelper
  def format_time(time)
    time.strftime("%d.%m.%y %H:%M")
  end
end
