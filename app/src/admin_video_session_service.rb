class AdminVideoSessionService
  attr_reader :params, :timezone
  def initialize(params, timezone)
    @params = params
    @timezone = timezone
  end

  def search
    results = search_by_trainer
    results = search_by_course(results) if search_by?(:course_id)
    results = search_by_determined_status(results) if search_by?(:determined_status)
    results = search_by_time_status(results) if search_by?(:time_status)
    video_sessions_decorator_wrapper(results)
  end

  private

  def search_by?(q)
    params[q].present?
  end

  def search_by_trainer
    return all_video_sessions unless search_by?(:instructor_id)
    all_video_sessions.where(instructor_id: params[:instructor_id])
  end

  def search_by_course(results)
    results.where(
      enrol: {
        course_version: { 'courses' => { id: params[:course_id] } }
      }
    )
  end

  def search_by_determined_status(results)
    results.where(
      status: params[:determined_status]
    )
  end

  def search_by_time_status(results)
    return upcoming_sessions(results) if params[:time_status] == 'Upcoming'
    results.where('end_date_time <= ?', TimezoneService.now_local(timezone).to_i)
  end

  def upcoming_sessions(results)
    results.where('end_date_time > ?', TimezoneService.now_local(timezone).to_i)
  end

  def all_video_sessions
    Repository::VideoSessionsResource.all_video_sessions
  end

  def video_sessions_decorator_wrapper(video_sessions)
    BookingVideoConferenceDecorator.wrap(video_sessions, timezone)
  end
end
