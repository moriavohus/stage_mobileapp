class Category < ApplicationRecord
  include Sluggable

  TONES = %w[lime sky lavender].freeze
  DOMAINS = %w[strength mind sleep nutrition].freeze

  has_many :posts, dependent: :restrict_with_error
  has_many :circles, dependent: :restrict_with_error

  validates :name, presence: true, length: { maximum: 60 }
  validates :tone, inclusion: { in: TONES }
  validates :domain, inclusion: { in: DOMAINS }

  scope :ordered, -> { order(:position, :name) }
end
