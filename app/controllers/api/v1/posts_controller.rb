module Api
  module V1
    class PostsController < BaseController
      def index
        scope = Post.published.of_kind(params[:kind]).recent.includes(:category, cover_attachment: :blob)
        scope = scope.joins(:category).where(categories: { slug: params[:category] }) if params[:category].present?
        total = scope.count
        per = per_page_param
        posts = scope.offset((page - 1) * per).limit(per)
        render json: { data: posts.map { |p| post_json(p) },
                       meta: { page: page, per_page: per, total: total, total_pages: (total.to_f / per).ceil } }
      end

      def show
        post = Post.published.includes(:category).find_by!(slug: params[:slug])
        render json: { data: post_json(post, full: true) }
      end
    end
  end
end
