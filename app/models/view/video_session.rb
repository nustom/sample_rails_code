module View
  class VideoSession
    attr_reader :video_session, :friendly_date, :friendly_time, :upcoming_days,
                :show_join_in_button, :zoom_join_url, :student_instruction,
                :timezone

    def initialize(video_session, timezone)
      @timezone = timezone
      @video_session = video_session
      @friendly_time = fetch_friendly_time
      @friendly_date = fetch_friendly_date
      @upcoming_days = fetch_upcoming_days
      @show_join_in_button = show_join_in_button?
      @zoom_join_url = fetch_zoom_url
      @student_instruction = fetch_student_instruction
    end

    def fetch_friendly_date
      [start_date, friendly_time].join(' - ')
    end

    def fetch_friendly_time
      [friendly_start_time, friendly_end_time].join(' - ') + " (GMT#{TimezoneService.current_timezone(
        timezone
      ).now.formatted_offset})"
    end

    def fetch_upcoming_days
      return unless conference_decorator.parsed_end > TimezoneService.now_local(timezone)
      (TimezoneService.parse_local(start_date, timezone) - TimezoneService.parse_local(now_date_str, timezone)).to_i
    end

    def show_join_in_button?
      conference_decorator.show_join_in_button?
    end

    def fetch_zoom_url
      conference_decorator.meeting_url
    end

    def fetch_student_instruction
      video_session.live_video_conference.student_instruction
    end

    def show_leave_meeting_btn?
      meeting_started_yet && !meeting_ended?
    end

    private

    def meeting_started_yet
      conference_decorator.parsed_start <= time_now
    end

    def meeting_ended?
      video_session.ended_at.present?
    end

    def now_date_str
      time_now.to_s(:au_long_date)
    end

    def time_now
      TimezoneService.now_local(timezone)
    end

    def conference_decorator
      @conference_decorator ||= BookingVideoConferenceDecorator.new(
        video_session, timezone
      )
    end

    def start_date
      conference_decorator.parsed_start.to_s(:au_long_date)
    end

    def end_date
      conference_decorator.parsed_end.to_s(:au_long_date)
    end

    def friendly_start_time
      conference_decorator.conference_start_time
    end

    def friendly_end_time
      conference_decorator.conference_end_time
    end
  end
end
