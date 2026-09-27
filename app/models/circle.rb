class Circle < ApplicationRecord
  include Sluggable

  belongs_to :category
  has_many :posts, class_name: "CirclePost", dependent: :destroy

  validates :name, presence: true
  validates :members_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  scope :ordered, -> { order(:position, :name) }

  def new_posts_count = posts.published.where(published_at: 3.days.ago..).count
end
