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

  def sanitize_post(post)
    sanitize(
      post.content,
      tags: %w[span],
      attributes: %w[class]
    )
      .gsub(/\s+/, " ")
      .html_safe
  end

  def show_filters_for?(model)
    if model == Activity
      params[:q] && (params[:q].keys - %w[content_search s]).any?
    else
      params[:q] && (params[:q].keys - %w[s]).any?
    end
  end
end
