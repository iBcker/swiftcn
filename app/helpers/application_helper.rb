module ApplicationHelper
  # def glyph(icon_name_postfix, hash={})
  #   content_tag :span, nil, hash.merge(class: "glyphicon glyphicon-#{icon_name_postfix.to_s.gsub('_','-')}")
  # end

  def lang(str,hash={})
    str.lang(hash)
  end

  def current_url(encode=false)
    encode ? url_encode(request.original_url) : request.original_url
  end

  def url_encode(url)
    URI.encode(url)
  end
  
  def url_decode(url)
    URI.decode(url)
  end

  def display_alert
    msg = ''
    msg << (render partial: "layouts/alert",locals:{messages:alert}) if alert.present?
    msg if msg.present?
  end

  def display_note
    msg = ''
    msg << (render partial: "layouts/notice",locals:{messages:notice}) if notice.present?
    msg if msg.present?
  end

  def topic_path_append_reply(topic,reply)
    topic_path(topic,reply:reply.id)+"#reply#{reply.id}"
  end
  
end
