class AssessmentQuestionOrder
  attr_reader :ordered_questions

  def initialize(ordered_questions)
    @ordered_questions = ordered_questions
  end

  def update_question_ordering
    convert_payload_to_i(ordered_questions).each do |question_id, order|
      Question.update(question_id, order: order)
    end
  end

  private

  def convert_payload_to_i(payload)
    new_payload = {}
    payload.each do |order_set|
      new_id = order_set['id'].to_i
      new_order = order_set['position'].to_i
      new_payload[new_id] = new_order
    end
    new_payload
  end
end
