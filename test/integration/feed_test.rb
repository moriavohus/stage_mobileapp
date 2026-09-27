require "test_helper"

class FeedTest < ActionDispatch::IntegrationTest
  setup do
    @circle = Circle.create!(name: "30+ и сила", category: categories(:sila), members_count: 214)
    @circle.posts.create!(author_nick: "Лиза_34", body: "Сегодня поднялась на шестой этаж.", supports_count: 12, published_at: 3.hours.ago)
  end

  test "лента: знания и обсуждения вместе, фильтр «Все · Знания · Обсуждения»" do
    get feed_path
    assert_response :success
    assert_select ".header-screen__title", "Лента"
    assert_select ".filter-bar .chip", 3
    assert_select ".chip--selected", "Все"
    assert_select ".row-exercise .ios-row__title", text: "30+ и сила"
    assert_select ".ios-row__subtitle", text: "214 участниц"
  end

  test "фильтр «Знания» скрывает обсуждения, «Обсуждения» — материалы" do
    get feed_path(section: "knowledge")
    assert_select ".chip--selected", "Знания"
    assert_select ".community-post", 0
    get feed_path(section: "discussions")
    assert_select ".chip--selected", "Обсуждения"
    assert_select ".community-post", 1
    assert_select ".card-program", 0
  end

  test "круг показывает посты с никами и поддержкой" do
    get circle_path(@circle)
    assert_response :success
    assert_select ".community-post .ios-row__title", "Лиза_34"
    assert_select ".button", text: "Поддержать · 12"
  end

  test "навигация: вкладка «Лента», на материале — режим Focus" do
    get feed_path
    assert_select ".nav-desktop .chip--selected", text: "Лента"
    assert_select ".tab-item[aria-current=page][aria-label=Лента]"
    get post_path("prisedaniya-u-steny")
    assert_select ".nav-desktop .button--plain", text: "← Назад"
  end
end
