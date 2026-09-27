module ContentHelper
  DOMAIN_LABELS = { "strength" => "Сила", "mind" => "Мозг", "sleep" => "Сон", "nutrition" => "Питание" }.freeze

  def domain_label(domain) = DOMAIN_LABELS.fetch(domain)

  def minutes_label(n)
    return if n.blank?
    form = if (n % 100).between?(11, 14) then "минут"
    elsif n % 10 == 1 then "минута"
    elsif (n % 10).between?(2, 4) then "минуты"
    else "минут"
    end
    "#{n} #{form}"
  end

  def plural_ru(n, one, few, many)
    form = if (n % 100).between?(11, 14) then many
    elsif n % 10 == 1 then one
    elsif (n % 10).between?(2, 4) then few
    else many
    end
    "#{n} #{form}"
  end

  def short_ago(time)
    s = (Time.current - time).to_i
    s < 3600 ? "#{[s / 60, 1].max} мин" : s < 86_400 ? "#{s / 3600} ч" : "#{s / 86_400} д"
  end

  def circle_row_props(circle)
    fresh = circle.new_posts_count
    { title: circle.name, subtitle: plural_ru(circle.members_count, "участница", "участницы", "участниц"),
      detail: (fresh.positive? ? "#{fresh} #{fresh == 1 ? "новый" : "новых"}" : nil), domain: circle.category.domain, href: circle_path(circle) }
  end

  def community_post_props(post)
    { author: post.author_nick, meta: "#{post.circle.name} · #{short_ago(post.published_at)}", text: post.body,
      support: "Поддержать · #{post.supports_count}", domain: post.circle.category.domain }
  end

  def feed_filter_items(current)
    [ [ "Все", nil ], [ "Знания", "knowledge" ], [ "Обсуждения", "discussions" ] ].map do |label, key|
      { label: label, href: feed_path(section: key), selected: current == key }
    end
  end

  def row_exercise_props(post)
    { title: post.title, subtitle: post.summary.to_s.truncate(40), detail: (post.duration_minutes && "#{post.duration_minutes} мин"),
      domain: post.category.domain, href: post_path(post) }
  end

  def card_program_props(post)
    { title: post.title, meta: post.summary.to_s.truncate(38), domain: post.category.domain, href: post_path(post) }
  end

  def article_item(post)
    base = { title: post.title, meta: minutes_label(post.duration_minutes) || post.kind_label, href: post_path(post) }
    post.cover_source.present? ? base.merge(kind: :photo, image: post.cover_source) : base.merge(kind: :article, domain: post.category.domain)
  end

  def category_filter_items(categories, current: nil)
    [ { label: "Все", href: categories_path, selected: current.nil? } ] +
      categories.map { |c| { label: domain_label(c.domain), domain: c.domain, href: category_path(c), selected: current == c } }
  end

  def kind_filter_items(current:, path:)
    [ { label: "Всё", href: path.call(nil), selected: current.nil? } ] +
      Post::KIND_PLURALS.map { |k, label| { label: label, href: path.call(k), selected: current == k } }
  end
end
