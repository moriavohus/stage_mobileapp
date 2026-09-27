class Subscriber < ApplicationRecord
  before_validation { self.email = email.to_s.strip.downcase }

  validates :email, presence: true, length: { maximum: 254 },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "выглядит неправильно" },
                    uniqueness: { message: "уже в списке — мы напишем, когда запустимся" }
end
