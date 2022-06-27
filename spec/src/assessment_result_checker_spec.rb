require 'rails_helper'

describe AssessmentResultChecker do
  let(:mock_assessment) { create(:assessment) }
  let(:checker)         { described_class.new(mock_assessment) }

  before do
    @question = create(:question, assessment: mock_assessment)
    @correct_option = create(:option, question: @question, correct: true)
    @incorrect_option = create(:option, question: @question, correct: false)
  end

  describe '#attempt' do
    subject { checker.attempt(attempts) }

    context 'all answers answered correctly' do
      before do
        @question2 = create(:question, assessment: mock_assessment)
        @correct_option2 = create(:option, question: @question2, correct: true)
      end

      let(:attempts) do
        {
          @question.id => @correct_option.id,
          @question2.id => @correct_option2.id
        }
      end
      it 'returns true' do
        expect(subject).to be true
      end

      context 'when hash keys are provided as strings' do
        let(:attempts) do
          {
            @question.id.to_s => @correct_option.id,
            @question2.id.to_s => @correct_option2.id
          }
        end
        it 'returns true' do
          expect(subject).to be true
        end
      end
    end

    context 'some answers incorrect' do
      let(:attempts) { { @question.id => @incorrect_option.id } }
      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'all answers not answered' do
      let(:attempts) { nil }
      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'some answers not answered' do
      let(:attempts) { { 123 => @correct_option.id } }
      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'some answers answered twice' do
      let(:attempts) { { @question.id => @correct_option.id } }
      it 'returns true' do
        expect(subject).to be true
      end
    end
  end
end
