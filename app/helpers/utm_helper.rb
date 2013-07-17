module UtmHelper

  # Appends utm query string to url, but doesn't show in name
  # TODO: this isn't very flexible, but it covers existing cases
  def utm_email_link_to(name, url)
    utm_query = '?utm_medium=email'
    url << utm_query
    name = name.gsub(utm_query, '')
    link_to name, url
  end

end
