module Api
  module V1
    class BaseController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound do
        render json: { error: "not_found" }, status: :not_found
      end

      private

      def page = [ params[:page].to_i, 1 ].max
      def per_page_param = params[:per_page].present? ? params[:per_page].to_i.clamp(1, 50) : 20

      def category_json(c, posts_count: nil)
        { id: c.id, slug: c.slug, name: c.name, description: c.description, domain: c.domain, tone: c.tone, position: c.position,
          posts_count: posts_count }.compact
      end

      def post_json(p, full: false)
        data = { id: p.id, slug: p.slug, title: p.title, kind: p.kind, kind_label: p.kind_label, summary: p.summary,
                 duration_minutes: p.duration_minutes, cover_url: absolute(p.cover_source), video_url: p.video_url.presence,
                 published_at: p.published_at&.iso8601, category: { slug: p.category.slug, name: p.category.name, domain: p.category.domain },
                 web_url: post_url(p) }
        data[:body] = p.body if full
        data
      end

      def absolute(path)
        return if path.blank?
        path.start_with?("http") ? path : "#{request.base_url}#{path}"
      end
    end
  end
end
