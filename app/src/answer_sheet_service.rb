class AnswerSheetService
  attr_reader :assessment, :correct_options

  def initialize(assessment_id)
    @assessment = Assessment.includes(:questions).find(assessment_id)
    load_correct_answers
  end

  def load_correct_answers
    @correct_options ||= Option.where(correct: true, question: assessment.questions)
  end

  def retrieve_correct_answers
    answers = {}
    @assessment.questions.each do |question|
      correct_option = correct_options.select do |option|
        option.question_id == question.id
      end

      next if correct_option.empty?
      correct_option = correct_option.first.id

      answers[question.id] = correct_option
    end
    answers
  end
end
