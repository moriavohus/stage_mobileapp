require "test_helper"

class AdminTest < ActionDispatch::IntegrationTest
  AUTH = { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "stage") }

  test "без пароля — 401" do
    get admin_root_path
    assert_response :unauthorized
  end

  test "с паролем открываются разделы и CSV" do
    [ admin_root_path, admin_categories_path, admin_posts_path, new_admin_post_path, admin_subscribers_path ].each do |path|
      get path, headers: AUTH
      assert_response :success, path
    end
    get admin_subscribers_path(format: :csv), headers: AUTH
    assert_includes response.body, "anna@example.com"
  end

  test "материал создаётся из админки и появляется на сайте" do
    assert_difference "Post.count", 1 do
      post admin_posts_path, headers: AUTH, params: { post: { category_id: categories(:sila).id, title: "Планка у стены", kind: "exercise", published: "1" } }
    end
    get post_path("planka-u-steny")
    assert_response :success
  end

  test "категорию с материалами удалить нельзя" do
    assert_no_difference "Category.count" do
      delete admin_category_path("sila"), headers: AUTH
    end
  end
end
