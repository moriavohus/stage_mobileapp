class FeedController < ApplicationController
  SECTIONS = %w[knowledge discussions].freeze

  def index
    @section = params[:section].presence_in(SECTIONS)
    published = Post.published.recent.includes(:category, cover_attachment: :blob)
    if @section != "discussions"
      @programs = published.of_kind("program").limit(6)
      @exercises = published.of_kind("exercise").limit(4)
      @articles = published.of_kind("article").limit(4)
    end
    if @section != "knowledge"
      @circles = Circle.ordered.includes(:category)
      @latest_post = CirclePost.published.recent.includes(:circle).first
    end
  end
end
