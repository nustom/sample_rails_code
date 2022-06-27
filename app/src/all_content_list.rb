class AllContentList
  attr_reader :search, :type_search

  def retrieve(params = {})
    @search = params[:search] || ''
    @type_search = params[:type] || ''

    params = {}
    params[:assessments] = all_assessments if include_assessments
    params[:learning]    = all_learnings   if include_learning
    params[:slideshow]   = all_slideshows  if include_slideshow
    params[:live_video_conference] = all_live_video_conference if include_live_video_conference
    ContentListService.new.construct_content(params).sort_by(&:title)
  end

  private

  def include_assessments
    type_search.empty? || type_search == 'Assessment'
  end

  def include_learning
    video_search || presentation_search || flippingbook_search || type_search.empty?
  end

  def include_slideshow
    type_search.empty? || type_search == 'Slideshow'
  end

  def include_live_video_conference
    type_search.empty? || type_search == 'Live Video Conference'
  end

  def video_search
    type_search == 'Video'
  end

  def flippingbook_search
    type_search == 'Flippingbook'
  end

  def presentation_search
    type_search == 'Presentation'
  end

  def all_assessments
    Assessment
      .where('lower(name) LIKE ?', "%#{search.downcase}%")
      .where(active: true)
  end

  def all_learnings
    item_query = Item
                 .where('lower(title) LIKE ?', "%#{search.downcase}%")
                 .where(active: true)

    item_query = item_query.where(type: 'Video') if video_search
    item_query = item_query.where(type: 'Articulate') if presentation_search
    item_query = item_query.where(type: 'Flippingbook') if flippingbook_search
    item_query
  end

  def all_slideshows
    Slideshow
      .where('lower(title) LIKE ?', "%#{search.downcase}%")
      .where(active: true)
  end

  def all_live_video_conference
    LiveVideoConference
      .where('lower(title) like ?', "%#{search.downcase}%")
  end
end
