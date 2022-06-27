class ChooseNextInstructorJob
  ##
  # choose next available instructor after one instructor canceled a meeting
  @queue = :video_session_choose_another_instructor

  def self.perform(video_session_id)
    VideoConference::ZoomMeetingManagement.new(video_session_id).create_meeting
    VideoSessionNotifications::VideoSessionEmailService.new(video_session_id).notify_new_session_to_trainer
  end
end
