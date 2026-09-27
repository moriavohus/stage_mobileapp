module Admin
  class SubscribersController < BaseController
    def index
      @subscribers = Subscriber.order(created_at: :desc)
      respond_to do |format|
        format.html
        format.csv do
          csv = "email,source,created_at\n" + @subscribers.map { |s| [ s.email, s.source, s.created_at.iso8601 ].join(",") }.join("\n")
          send_data csv, filename: "stage-subscribers-#{Date.current}.csv", type: "text/csv"
        end
      end
    end

    def destroy
      Subscriber.find(params[:id]).destroy
      redirect_to admin_subscribers_path, notice: "Адрес удалён", status: :see_other
    end
  end
end
