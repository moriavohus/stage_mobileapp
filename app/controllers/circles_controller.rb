class CirclesController < ApplicationController
  def show
    @circle = Circle.includes(:category).find_by!(slug: params[:slug])
    @posts = @circle.posts.published.recent
  end
end
