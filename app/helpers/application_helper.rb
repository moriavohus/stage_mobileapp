module ApplicationHelper
  def nav_items = [ [ "today", "today", "Сегодня", root_path ], [ "library", "library", "Лента", feed_path ], [ "profile", "profile", "О проекте", about_path ] ]

  def nav_section
    return "library" if controller_name.in?(%w[feed categories posts circles])
    action_name == "about" ? "profile" : "today"
  end

  def page_title(title = nil)
    [ title, "Stage — Staging, not aging" ].compact.join(" · ")
  end

  def post_card_classes(post) = "card card--#{post.category.tone}"

  def duration_label(post)
    post.duration_minutes ? "#{post.duration_minutes} мин" : nil
  end

  def video_embed_url(url)
    return if url.blank?
    if (id = url[%r{(?:youtu\.be/|youtube\.com/(?:watch\?v=|embed/))([\w-]{6,})}, 1])
      "https://www.youtube-nocookie.com/embed/#{id}"
    elsif (m = url.match(%r{vk\.com/video(-?\d+)_(\d+)}))
      "https://vk.com/video_ext.php?oid=#{m[1]}&id=#{m[2]}"
    end
  end
end
