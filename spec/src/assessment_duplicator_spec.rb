require 'rails_helper'

describe AssessmentDuplicator do
  subject { described_class.new(assessment) }
  let!(:assessment) { create(:assessment) }
  let!(:question)   { create(:question, assessment: assessment) }
  let!(:option)     { create(:option, question: question) }

  describe '#run' do
    let(:new_assessment) { subject.run }
    let(:new_question)   { subject.run.questions.first }
    describe 'assessment' do
      it 'copies the assessment name' do
        expect(new_assessment.name).to eq(assessment.name + ' - Duplicate')
      end
      it 'copies the assessment instructions' do
        expect(new_assessment.instructions).to eq(assessment.instructions)
      end
      it 'copies the assessment active state' do
        expect(new_assessment.active).to eq(assessment.active)
      end
    end
    describe 'question' do
      it 'copies the questions' do
        expect(new_assessment.questions.length).to eq(1)
      end
      it 'copies the question title' do
        expect(new_question.title).to eq(question.title)
      end
      it 'copies the question body' do
        expect(new_question.body).to eq(question.body)
      end
      it 'copies the question type' do
        expect(new_question.type).to eq(question.type)
      end
    end
    describe 'option' do
      let(:new_option) { subject.run.questions.first.options.first }
      it 'copies the options' do
        expect(new_question.options.length).to eq(1)
      end
      it 'copies the question body' do
        expect(new_option.body).to eq(option.body)
      end
      it 'copies the question correct state' do
        expect(new_option.correct).to eq(option.correct)
      end
    end
  end
end
