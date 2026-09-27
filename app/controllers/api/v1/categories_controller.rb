module Api
  module V1
    class CategoriesController < BaseController
      def index
        counts = Post.published.group(:category_id).count
        render json: { data: Category.ordered.map { |c| category_json(c, posts_count: counts.fetch(c.id, 0)) } }
      end

      def show
        category = Category.find_by!(slug: params[:slug])
        posts = category.posts.published.of_kind(params[:kind]).recent.includes(:category, cover_attachment: :blob)
        render json: { data: category_json(category).merge(posts: posts.map { |p| post_json(p) }) }
      end
    end
  end
end
