require "test_helper"

class ApiTest < ActionDispatch::IntegrationTest
  test "категории с количеством опубликованных материалов" do
    get api_v1_categories_path
    assert_response :success
    sila = response.parsed_body["data"].find { |c| c["slug"] == "sila" }
    assert_equal 1, sila["posts_count"]
  end

  test "материалы: фильтр по теме и типу, пагинация, без черновиков" do
    get api_v1_posts_path, params: { category: "son", kind: "exercise", per_page: 1 }
    body = response.parsed_body
    assert_equal [ "dyhanie-4-7-8" ], body["data"].map { |p| p["slug"] }
    assert_equal({ "page" => 1, "per_page" => 1, "total" => 1, "total_pages" => 1 }, body["meta"])
    get api_v1_posts_path
    assert_not_includes response.parsed_body["data"].map { |p| p["slug"] }, "chernovik"
  end

  test "материал целиком и 404 для черновика" do
    get api_v1_post_path("prisedaniya-u-steny")
    assert_equal "Текст", response.parsed_body.dig("data", "body")
    get api_v1_post_path("chernovik")
    assert_response :not_found
  end

  test "CORS разрешает чтение с домена VK, запись не разрешена" do
    get api_v1_categories_path, headers: { "Origin" => "https://vk.com" }
    assert_equal "*", response.headers["Access-Control-Allow-Origin"]
    process :options, api_v1_posts_path, headers: { "Origin" => "https://vk.com", "Access-Control-Request-Method" => "GET" }
    assert_equal "GET, HEAD, OPTIONS", response.headers["Access-Control-Allow-Methods"]
  end
end
