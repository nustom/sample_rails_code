class AssessmentDuplicator
  attr_reader :old_assessment

  def initialize(assessment)
    @old_assessment = assessment
  end

  def run
    new_assessment = create_assessment
    duplicate_questions(new_assessment)
    new_assessment
  end

  private

  def create_assessment
    Assessment.create(
      name: new_name,
      instructions: old_assessment.instructions,
      active: old_assessment.active
    )
  end

  def new_name
    old_assessment.name + ' - Duplicate'
  end

  def duplicate_questions(new_assessment)
    old_assessment.questions.each do |question|
      new_question = Question.create(
        title: question.title,
        body: question.body,
        type: question.type,
        order: question.order,
        assessment: new_assessment
      )

      duplicate_options(question, new_question)
    end
  end

  def duplicate_options(old_question, new_question)
    old_question.options.each do |option|
      Option.create(
        body: option.body,
        correct: option.correct,
        question_id: new_question.id
      )
    end
  end
end
