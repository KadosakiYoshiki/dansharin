module ApplicationHelper
  include Pagy::Frontend

  def auto_link(text)
    uri_reg = URI.regexp(%w[http https])
    body = simple_format(text).gsub(uri_reg) { %{<object><a href='#{$&}' target='_blank' rel='noopener noreferrer'>#{$&}</a></object>} }.html_safe
    sanitize(body, tags: %w(a p br object), attributes: %w(href target rel))
  end
end
