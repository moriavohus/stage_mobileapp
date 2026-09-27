require "test_helper"

class PublicPagesTest < ActionDispatch::IntegrationTest
  test "главная, о проекте, темы и материал открываются" do
    [ root_path, about_path, design_path, categories_path, category_path("sila"), posts_path, post_path("prisedaniya-u-steny") ].each do |path|
      get path
      assert_response :success, path
    end
  end

  test "черновик и несуществующий материал — 404" do
    get post_path("chernovik")
    assert_response :not_found
  end

  test "подписка сохраняет почту в нижнем регистре" do
    assert_difference "Subscriber.count", 1 do
      post subscribers_path, params: { subscriber: { email: "  New@Example.com " } }
    end
    assert_redirected_to root_path(anchor: "subscribe")
    assert Subscriber.exists?(email: "new@example.com")
  end

  test "повтор и неверная почта не сохраняются и показывают ошибку" do
    assert_no_difference "Subscriber.count" do
      post subscribers_path, params: { subscriber: { email: "anna@example.com" } }
      post subscribers_path, params: { subscriber: { email: "not-an-email" } }
    end
    assert_response :unprocessable_entity
    assert_select ".field__error"
  end
end
