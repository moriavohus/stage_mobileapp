class Post < ApplicationRecord
  include Sluggable

  KINDS = { "article" => "Статья", "exercise" => "Упражнение", "program" => "Программа" }.freeze
  KIND_PLURALS = { "article" => "Статьи", "exercise" => "Упражнения", "program" => "Программы" }.freeze

  belongs_to :category
  attr_accessor :remove_cover
  has_one_attached :cover

  validates :title, presence: true, length: { maximum: 120 }
  validates :kind, inclusion: { in: KINDS.keys }
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :cover_url, :video_url, format: { with: %r{\A(https?://|/)\S+\z}, message: "должна быть ссылкой" }, allow_blank: true

  before_save :stamp_published_at

  scope :published, -> { where(published: true).where(published_at: ..Time.current) }
  scope :recent, -> { order(published_at: :desc, id: :desc) }
  scope :of_kind, ->(kind) { KINDS.key?(kind.to_s) ? where(kind: kind) : all }

  def kind_label = KINDS.fetch(kind, kind)

  def cover_source
    cover.attached? ? Rails.application.routes.url_helpers.rails_blob_path(cover, only_path: true) : cover_url.presence
  end

  private

  def stamp_published_at
    self.published_at ||= Time.current if published?
  end
end
