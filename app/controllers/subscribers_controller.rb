class SubscribersController < PagesController
  def create
    @subscriber = Subscriber.new(email: params.dig(:subscriber, :email), source: "landing")

    if @subscriber.save
      redirect_to root_path(anchor: "subscribe"), notice: "Спасибо! Напишем, когда Stage откроется."
    else
      load_home
      render "pages/home", status: :unprocessable_entity
    end
  end
end
