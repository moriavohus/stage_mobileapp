module Admin
  class DashboardController < BaseController
    def show
      @stats = { "Категорий" => Category.count, "Материалов" => Post.count, "Опубликовано" => Post.published.count, "Подписчиц" => Subscriber.count }
      @latest = Post.includes(:category).order(updated_at: :desc).limit(5)
    end
  end
end
