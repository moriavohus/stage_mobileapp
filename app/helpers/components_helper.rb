module ComponentsHelper
  IMAGES = Rails.root.join("app/assets/images")
  DOMAINS = %w[strength mind sleep nutrition].freeze

  def icon(name, size: 24, css: nil)
    tag.span(svg_file("icons/#{name}"), class: [ "icon", css ], style: ("--icon-size: #{size}px" unless size == 24), aria: { hidden: true })
  end

  def stage_glyph(domain, css: nil)
    tag.span(svg_file("stage/#{domain}"), class: [ "stage-glyph", css ], aria: { hidden: true })
  end

  def domain_icon(domain, size: 24, css: nil) = icon("domain-#{domain}", size:, css:)

  def domain_of(record) = record.respond_to?(:domain) ? record.domain : record.category.domain

  def atom(name, **locals) = render("components/atoms/#{name}", **locals)
  def molecule(name, **locals) = render("components/molecules/#{name}", **locals)
  def organism(name, **locals) = render("components/organisms/#{name}", **locals)
  def widget(name, **locals) = render("components/widgets/#{name}", **locals)

  private

  def svg_file(path)
    Rails.cache.fetch([ "svg", path ]) { IMAGES.join("#{path}.svg").read }.html_safe
  end
end
