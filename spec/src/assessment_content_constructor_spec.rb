require 'rails_helper'

describe Contents::AssessmentContentConstructor do
  let(:name)         { 'Assessment Test' }
  let(:id)           { 1 }
  let(:content_id)   { 123 }

  let(:assessment) { double(name: name, id: id) }
  let(:content)    { double(id: content_id, order: 0) }
  let(:mock_friendly) { double(run: 'FriendlyContent') }
  subject { described_class.build(assessment, content) }
  before do
    allow(FriendlyContent).to receive(:new).and_return(mock_friendly)
  end

  describe '#build' do
    it 'creates simple content object with correct params' do
      expected_options = {}
      expected_options[:title] = name
      expected_options[:assessment_id] = id
      expected_options[:type] = 'Assessment'
      expected_options[:id]   = content_id
      expected_options[:order] = 0
      expected_options[:friendly_type] = 'FriendlyContent'

      expect(Core::SimpleContent).to receive(:new).with(expected_options)
      subject
    end

    it 'returns a simple content object' do
      expect(subject).to be_instance_of(Core::SimpleContent)
    end

    it 'calls the FriendlyContent decorater correctly' do
      expect(FriendlyContent).to receive(:new).with('Assessment')
      subject
    end

    context 'without a content record' do
      let(:content) { nil }
      it 'allows for no content record to be passed' do
        expect(subject).to be_instance_of(Core::SimpleContent)
      end
    end
  end
end
