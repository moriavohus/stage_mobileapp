class CategoriesController < ApplicationController
  def index
    @categories = Category.ordered
    @counts = Post.published.group(:category_id).count
  end

  def show
    @category = Category.find_by!(slug: params[:slug])
    @kind = params[:kind].presence_in(Post::KINDS.keys)
    @posts = @category.posts.published.of_kind(@kind).recent.includes(cover_attachment: :blob)
  end
end
