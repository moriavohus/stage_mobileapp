module Admin
  class PostsController < BaseController
    before_action :set_post, only: %i[edit update destroy]

    def index
      @posts = Post.includes(:category).order(created_at: :desc)
      @posts = @posts.where(category_id: params[:category_id]) if params[:category_id].present?
    end

    def new = @post = Post.new(kind: "article", published: true)
    def edit; end

    def create
      @post = Post.new(post_params)
      @post.save ? redirect_to(admin_posts_path, notice: "Материал создан") : render(:new, status: :unprocessable_entity)
    end

    def update
      @post.cover.purge if params.dig(:post, :remove_cover) == "1"
      @post.update(post_params) ? redirect_to(admin_posts_path, notice: "Материал обновлён") : render(:edit, status: :unprocessable_entity)
    end

    def destroy
      @post.destroy
      redirect_to admin_posts_path, notice: "Материал удалён", status: :see_other
    end

    private

    def set_post = @post = Post.find_by!(slug: params[:id])
    def post_params = params.require(:post).permit(:category_id, :title, :slug, :kind, :summary, :body, :duration_minutes, :cover, :cover_url, :video_url, :published, :published_at).except(:remove_cover)
  end
end
