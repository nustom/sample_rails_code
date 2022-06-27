class AssessmentLiveChecker
  attr_reader :assessment

  def initialize(assessment)
    @assessment = assessment
  end

  def run
    return true if assessment.contents.any?
    false
  end
end
