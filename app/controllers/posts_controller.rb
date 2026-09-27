class PostsController < ApplicationController
  def index
    @kind = params[:kind].presence_in(Post::KINDS.keys)
    @posts = Post.published.of_kind(@kind).recent.includes(:category, cover_attachment: :blob)
  end

  def show
    @post = Post.published.includes(:category).find_by!(slug: params[:slug])
    @related = @post.category.posts.published.where.not(id: @post.id).recent.limit(3)
  end
end
