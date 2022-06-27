require 'rails_helper'

describe AssessmentSubmissionsStatusChecker do
  let(:enrol) { create(:enrol) }
  let(:assessment) { create(:assessment) }
  let!(:question) { create(:short_answer_question, assessment: assessment) }
  let!(:other_question) { create(:short_answer_question, assessment: assessment) }

  describe '#status' do
    context 'assessment not started' do
      it 'return questions peding' do
        service = described_class.new(enrol, assessment)

        expect(service.status).to eql('questions_pending')
      end
    end

    context 'incomplete assessment' do
      it 'return questions peding' do
        create(:submission_correct_state, enrol: enrol, question: other_question)

        service = described_class.new(enrol, assessment)

        expect(service.status).to eql('questions_pending')
      end
    end

    context 'submissions waiting to be marked' do
      it 'return the status waiting marking' do
        create(:submission_correct_state, enrol: enrol, question: other_question)

        create(:submission_mark_state, enrol: enrol, question: question)

        service = described_class.new(enrol, assessment)

        expect(service.status).to eql('waiting_marking')
      end
    end

    context 'submissions already marked as incorrect' do
      it 'return a status warning that some submissions was marked as incorrect' do
        create(:submission_mark_state, enrol: enrol, question: other_question)
        create(:submission_correct_state, enrol: enrol, question: other_question)

        create(:submission_mark_state, enrol: enrol, question: question)
        create(:submission_incorrect_state, enrol: enrol, question: question)

        service = described_class.new(enrol, assessment)

        expect(service.status).to eql('incorrect_submissions')
      end
    end

    context 'all submissions marked as correct' do
      it 'return a status warning that some submissions was marked as incorrect' do
        create(:submission_correct_state, enrol: enrol, question: question)
        create(:submission_correct_state, enrol: enrol, question: other_question)

        service = described_class.new(enrol, assessment)

        expect(service.status).to eql('complete')
      end
    end
  end
end
