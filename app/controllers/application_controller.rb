class ApplicationController < ActionController::Base
  include Authentication

  before_action :initialize_activities_q

  # bootstrap alert types
  add_flash_types :primary,
                  :secondary,
                  :success,
                  :danger,      # alias: alert
                  :warning,
                  :info,        # alias: notice
                  :light,
                  :dark

  private

  def initialize_activities_q
    @activities_q = Activity.ransack
  end
end
