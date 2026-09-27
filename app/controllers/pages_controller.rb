class PagesController < ApplicationController
  def home
    load_home
    @subscriber = Subscriber.new
  end

  def about; end

  def design; end

  private

  def load_home
    published = Post.published.recent.includes(:category, cover_attachment: :blob)
    @categories = Category.ordered
    @counts = Post.published.group(:category_id).count
    @exercises = published.of_kind("exercise").limit(4)
    @programs = published.of_kind("program").limit(6)
    @articles = published.of_kind("article").limit(4)
  end
end
