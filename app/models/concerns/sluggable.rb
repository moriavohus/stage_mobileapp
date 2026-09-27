module Sluggable
  extend ActiveSupport::Concern

  included do
    before_validation :assign_slug, if: -> { slug.blank? }
    validates :slug, presence: true, uniqueness: true,
                     format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "только латиница, цифры и дефисы" }
  end

  def to_param = slug

  private

  def slug_source = respond_to?(:title) ? title : name

  def assign_slug
    base = I18n.transliterate(slug_source.to_s, locale: :ru).parameterize
    candidate = base
    counter = 2
    while self.class.where.not(id: id).exists?(slug: candidate)
      candidate = "#{base}-#{counter}"
      counter += 1
    end
    self.slug = candidate
  end
end
