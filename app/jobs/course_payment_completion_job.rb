##
# This job is used for sending out emails when a student has completed a payment
# for a course
class CoursePaymentCompletionJob
  @queue = :course_payment_completion_queue
  def self.perform(enrol_id)
    NotifyCompletedPaymentService.new(enrol_id).run
  end
end
