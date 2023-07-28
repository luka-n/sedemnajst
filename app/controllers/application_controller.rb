class ApplicationController < ActionController::Base
  include Authentication

  # bootstrap alert types
  add_flash_types :primary,
                  :secondary,
                  :success,
                  :danger,      # alias: alert
                  :warning,
                  :info,        # alias: notice
                  :light,
                  :dark
end
