module ApplicationHelper
  def format_time(time)
    time.strftime("%d.%m.%y %H:%M")
  end

  def sortable(column_name, title)
    direction = column_name == @sort_column && @sort_direction == "asc" ? "desc" : "asc"
    link_to title, sort: column_name, sort_direction: direction
  end
end
