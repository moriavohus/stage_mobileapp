module Admin
  # в production без ADMIN_USER / ADMIN_PASSWORD админка закрыта
  class BaseController < ApplicationController
    layout "admin"
    before_action :authenticate_admin!

    private

    def authenticate_admin!
      user = ENV["ADMIN_USER"].presence || (Rails.env.production? ? nil : "admin")
      password = ENV["ADMIN_PASSWORD"].presence || (Rails.env.production? ? nil : "stage")
      return head(:service_unavailable) if user.nil? || password.nil?

      authenticate_or_request_with_http_basic("Stage admin") do |u, p|
        ActiveSupport::SecurityUtils.secure_compare(u, user) & ActiveSupport::SecurityUtils.secure_compare(p, password)
      end
    end
  end
end
