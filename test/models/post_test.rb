require "test_helper"

class PostTest < ActiveSupport::TestCase
  test "адрес собирается транслитерацией из русского заголовка и остаётся уникальным" do
    a = Post.create!(category: categories(:sila), title: "Сила за 4 недели", kind: "program", published: true)
    b = Post.create!(category: categories(:sila), title: "Сила за 4 недели", kind: "program", published: true)
    assert_equal "sila-za-4-nedeli", a.slug
    assert_equal "sila-za-4-nedeli-2", b.slug
  end

  test "published скрывает черновики и будущие публикации" do
    Post.create!(category: categories(:son), title: "Завтра", kind: "article", published: true, published_at: 1.day.from_now)
    titles = Post.published.pluck(:title)
    assert_includes titles, "Приседания у стены"
    assert_not_includes titles, "Черновик"
    assert_not_includes titles, "Завтра"
  end
end
