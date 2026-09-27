module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: %i[edit update destroy]

    def index = @categories = Category.ordered.left_joins(:posts).select("categories.*, COUNT(posts.id) AS posts_count").group("categories.id")
    def new = @category = Category.new(position: Category.maximum(:position).to_i + 1)
    def edit; end

    def create
      @category = Category.new(category_params)
      @category.save ? redirect_to(admin_categories_path, notice: "Категория создана") : render(:new, status: :unprocessable_entity)
    end

    def update
      @category.update(category_params) ? redirect_to(admin_categories_path, notice: "Категория обновлена") : render(:edit, status: :unprocessable_entity)
    end

    def destroy
      if @category.destroy
        redirect_to admin_categories_path, notice: "Категория удалена", status: :see_other
      else
        redirect_to admin_categories_path, alert: @category.errors.full_messages.to_sentence, status: :see_other
      end
    end

    private

    def set_category = @category = Category.find_by!(slug: params[:id])
    def category_params = params.require(:category).permit(:name, :slug, :description, :tone, :domain, :position)
  end
end
