require 'rails_helper'

describe WalkthroughService do
  subject  { described_class.new(type, mock_student) }

  describe '#run' do
    let(:mock_student) do
      instance_double(Student, watched_walkthrough: watched, update: nil)
    end
    context 'when walkthrough type is student:enrol' do
      let(:type) { 'student:enrol' }
      context 'when the student has NOT watched it' do
        let(:watched) { false }
        it 'updates the student record to reflect that it has been watched' do
          expect(mock_student).to receive(:update)
            .with(watched_walkthrough: true)
          subject.run
        end
        it 'returns true' do
          expect(subject.run).to be true
        end
      end
      context 'when the student has watched it' do
        let(:watched) { true }
        it 'returns false' do
          expect(subject.run).to be false
        end
      end
    end
  end
end
