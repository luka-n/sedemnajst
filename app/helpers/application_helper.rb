module ApplicationHelper
  def format_time(time)
    time.strftime("%d.%m.%y %H:%M")
  end

  def highlight_pg_search(model)
    sanitize(
      model.pg_search_highlight,
      tags: %w[span],
      attributes: %w[class]
    )
      .gsub(/\s+/, " ")
      .html_safe
  end
end
