class CirclePost < ApplicationRecord
  belongs_to :circle

  validates :author_nick, presence: true, length: { maximum: 40 }
  validates :body, presence: true, length: { maximum: 2000 }

  before_save { self.published_at ||= Time.current if published }

  scope :published, -> { where(published: true).where(published_at: ..Time.current) }
  scope :recent, -> { order(published_at: :desc) }
end
