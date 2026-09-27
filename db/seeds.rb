categories = [
  { slug: "sila", name: "Сила и движение", domain: "strength", tone: "sky", position: 1,
    description: "Мышцы и кости, которые понадобятся в 50 и 60. Короткие упражнения дома." },
  { slug: "mozg", name: "Когнитивное здоровье", domain: "mind", tone: "lavender", position: 2,
    description: "Память, внимание и новизна — тренируем мозг так же, как тело." },
  { slug: "son", name: "Сон и восстановление", domain: "sleep", tone: "lime", position: 3,
    description: "Ритуалы вечера и отдыха, которые помогают восстанавливаться." },
  { slug: "pitanie", name: "Питание", domain: "nutrition", tone: "lavender", position: 4,
    description: "Простые привычки на тарелке: белок, клетчатка, вода." }
].to_h { |attrs| [ attrs[:slug], Category.find_or_initialize_by(slug: attrs[:slug]).tap { |c| c.update!(attrs) } ] }

posts = [
  [ "sila", "program", "Сила за 4 недели", "28 коротких заданий, которые складываются в привычку", 10, nil ],
  [ "mozg", "program", "Ясная голова", "21 задание на внимание и память", 7, nil ],
  [ "son", "program", "Спокойный сон", "14 вечерних ритуалов без экранов", 10, nil ],
  [ "pitanie", "program", "Тарелка 30+", "14 шагов к тарелке, которая даёт силы", 5, nil ],
  [ "sila", "exercise", "Приседания у стены", "Сильные ноги сейчас — лёгкая лестница в шестьдесят.", 6, nil ],
  [ "sila", "exercise", "Отжимания от стены", "Руки и спина, которые легко поднимают сумки и детей.", 5, nil ],
  [ "mozg", "exercise", "Пять новых слов", "Новизна — лучшая зарядка для памяти.", 5, nil ],
  [ "mozg", "exercise", "Прогулка без телефона", "Внимание отдыхает, когда ему не мешают уведомления.", 15, nil ],
  [ "son", "exercise", "Дыхание 4-7-8", "Помогает телу переключиться в режим отдыха.", 5, nil ],
  [ "son", "exercise", "Час без экрана вечером", "Мягкий переход ко сну без синего света.", 60, nil ],
  [ "pitanie", "exercise", "Белок в завтраке", "Утро с белком — ровная энергия до обеда.", 10, nil ],
  [ "pitanie", "exercise", "Полтарелки овощей", "Клетчатка и цвет на тарелке — без подсчёта калорий.", 5, nil ],
  [ "mozg", "article", "Перименопауза простыми словами", "Что это за этап и почему к нему можно готовиться заранее.", 6, "/covers/mind-perimenopause.jpg" ],
  [ "sila", "article", "Почему мышцы важны уже в 30", "Мышечная масса — это запас на годы вперёд.", 3, nil ],
  [ "son", "article", "Как кофеин влияет на сон", "И почему вечерний кофе может мешать отдыху.", 4, "/covers/sleep-caffeine.jpg" ],
  [ "pitanie", "article", "Белок после 30: что важно знать", "Простые источники белка без сложных диет.", 5, nil ],
  [ "sila", "article", "Кости любят нагрузку", "Какие движения поддерживают крепость костей.", 4, "/covers/strength-bones.jpg" ],
  [ "son", "article", "Вечерний ритуал за 10 минут", "Три шага, чтобы тело поняло: пора отдыхать.", 3, nil ],
  [ "mozg", "article", "Сон и память: как они связаны", "Почему после хорошей ночи легче запоминать.", 4, nil ],
  [ "pitanie", "article", "Вода и энергия днём", "Небольшие привычки, которые помогают не уставать.", 3, nil ]
]

body = <<~TEXT
  Это тестовый материал. В реальном продукте здесь будет текст, проверенный экспертами.

  Одно маленькое действие в день — и сила копится слоями. Пропустила день? Ничего не потеряно: слой просто добавится завтра.

  Если что-то беспокоит — обсуди с врачом. Stage — про заботу о себе, а не про лечение.
TEXT

posts.each_with_index do |(cat, kind, title, summary, minutes, cover), i|
  post = Post.find_or_initialize_by(title: title)
  post.update!(category: categories.fetch(cat), kind: kind, summary: summary, body: body, duration_minutes: minutes,
               cover_url: cover, published: true, published_at: (posts.size - i).days.ago)
end

%w[anna@example.com vera@example.com lena@example.com].each { |email| Subscriber.find_or_create_by!(email: email) { |s| s.source = "seed" } }

circles = {
  "30+ и сила" => { cat: "sila", members: 214, description: "Сила и движение без гонки за результатом.", position: 1,
    posts: [ [ "Лиза_34", "Третью неделю делаю приседания у стены. Сегодня поднялась на шестой этаж и даже не заметила.", 12, 3.hours ],
             [ "Аня_Сон", "Начала с трёх минут в день — оказалось, этого достаточно, чтобы не бросить.", 8, 5.hours ],
             [ "Марина_40", "Как здорово! Я тоже заметила разницу на лестнице.", 3, 1.day ] ] },
  "Спокойный сон" => { cat: "son", members: 98, description: "Вечерние ритуалы и восстановление.", position: 2,
    posts: [ [ "Вера_36", "Перенесла кофе на утро — засыпаю быстрее. Делюсь, вдруг кому-то поможет.", 6, 7.hours ],
             [ "Оля_38", "Дыхание 4-7-8 перед сном стало моим любимым слоем дня.", 4, 2.days ] ] }
}
circles.each do |name, c|
  circle = Circle.find_or_initialize_by(name: name)
  circle.update!(category: categories.fetch(c[:cat]), members_count: c[:members], description: c[:description], position: c[:position])
  c[:posts].each do |nick, body, supports, ago|
    post = circle.posts.find_or_initialize_by(author_nick: nick, body: body)
    post.update!(supports_count: supports, published: true, published_at: ago.ago)
  end
end

puts "Категорий: #{Category.count}, материалов: #{Post.count}, кругов: #{Circle.count}, постов в кругах: #{CirclePost.count}, подписчиц: #{Subscriber.count}"
