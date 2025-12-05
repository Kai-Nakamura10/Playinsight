module ApplicationHelper
  def meta_title
    content_for(:meta_title).presence || default_meta_title
  end

  def meta_description
    content_for(:meta_description).presence || default_meta_description
  end

  def meta_image
    content_for(:meta_image).presence || default_meta_image
  end

  def meta_image_alt
    content_for(:meta_image_alt).presence || default_meta_image_alt
  end

  def meta_type
    content_for(:meta_type).presence || "website"
  end

  def meta_url
    content_for(:meta_url).presence || canonical_url(request.original_url)
  end

  def meta_twitter_card
    content_for(:meta_twitter_card).presence || "summary_large_image"
  end

  def meta_twitter_site
    content_for(:meta_twitter_site).presence || "@papa55106109"
  end

  def meta_site_name
    "Playinsight"
  end

  private

  def default_meta_title
    "試合分析をしてチームを強化しよう"
  end

  def default_meta_description
    "バスケの戦術を理解しよう"
  end

  def default_meta_image
    image_url("Frame 6.png")
  end

  def default_meta_image_alt
    "Playinsight - バスケ戦術分析アプリ"
  end

  def canonical_url(url)
    host = ENV["APP_HOST"]
    return url if host.blank?

    uri = URI.parse(url)
    uri.scheme = "https"
    uri.host = host
    uri.to_s
  rescue URI::InvalidURIError
    url
  end
end
