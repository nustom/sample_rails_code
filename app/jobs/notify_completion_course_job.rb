##
# This job is used for sending out emails when a student has completed a course
# Also with AVETMISS, USI, Payment completed if applicable
# each course need a email field setup for this purpose
class NotifyCompletionCourseJob
  @queue = :notify_completed_course
  def self.perform(enrol_id)
    NotifyCompletedCourseService.new(enrol_id).run
  end
end
