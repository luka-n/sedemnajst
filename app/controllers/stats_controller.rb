class StatsController < ApplicationController
  def index
    @q = Activity.ransack(params[:q])

    @q.remote_created_at_in_date_range ||=
      [
        (Date.today - 1.week).strftime("%d.%m.%Y"),
        Date.today.strftime("%d.%m.%Y")
      ].join(" - ")

    @data_by_source_type = {}

    %w[Message Post Topic].each do |source_type|
      @data_by_source_type[source_type] =
        @q
          .result(distinct: true)
          .where(source_type: source_type)
    end
  end
end
