# VK mini app ходит в API с других доменов
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*ENV.fetch("CORS_ORIGINS", "*").split(",").map(&:strip))
    resource "/api/*", headers: :any, methods: %i[get head options], max_age: 600
  end
end
