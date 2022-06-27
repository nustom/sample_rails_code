module ItemsHelper
  def preview_learning
    case @item.type
    when 'Video'
      render 'shared/video_learning'
    when 'Articulate'
      render 'shared/presentation_learning'
    when 'Flippingbook'
      render 'shared/flippingbook_learning'
    end
  end

  def video_embed(url)
    c = Conred::Video.new(
      video_url: url,
      width: 285,
      height: 185,
      error_message: 'Video URL is invalid'
    )

    c.code.html_safe
  end
end
