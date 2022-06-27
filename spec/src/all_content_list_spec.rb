require 'rails_helper'

RSpec.describe AllContentList do
  let(:search)      {}
  let(:type_search) {}
  let(:params) do
    {
      search: search,
      type: type_search
    }
  end

  subject { described_class.new.retrieve(params) }

  before do
    create(:assessment)
    create(:presentation_item)
    create(:video_item)
    create(:slideshow)
  end

  describe '#run' do
    context 'with an assessment type search' do
      let(:type_search) { 'Assessment' }
      it 'returns active assessments' do
        create(:assessment, active: false)
        expect(subject.length).to eq(1)
      end

      context 'with a keyword search' do
        let(:search) { 'rams' }
        before do
          Assessment.first.update(name: 'Ramsay')
          create(:assessment, name: 'My Exam')
        end
        it 'returns assessments against keywords' do
          expect(subject.length).to eq(1)
        end
      end
    end

    context 'with an video type search' do
      let(:type_search) { 'Video' }
      it 'returns active videos' do
        create(:video_item, active: false)
        expect(subject.length).to eq(1)
      end

      context 'with a keyword search' do
        let(:search) { 'rams' }
        before do
          Item.where(type: 'Video').first.update(title: 'Ramsay')
          create(:video_item, title: 'My Exam')
        end
        it 'returns videos against keywords' do
          expect(subject.length).to eq(1)
        end
      end
    end

    context 'with an flippingbook type search' do
      let(:type_search) { 'Flippingbook' }
      it 'returns active flippingbooks' do
        create(:flippingbook_item, active: false)
        expect(subject.length).to eq(0)
      end

      context 'with a keyword search' do
        let(:search) { 'rams' }
        before do
          create(:flippingbook_item, title: 'Ramsay')
          create(:flippingbook_item, title: 'new flip')
        end
        it 'returns flippingbooks against keywords' do
          expect(subject.length).to eq(1)
        end
      end
    end

    context 'with a presentation type search' do
      let(:type_search) { 'Presentation' }
      it 'returns active presentations' do
        create(:presentation_item, active: false)
        expect(subject.length).to eq(1)
      end

      context 'with a keyword search' do
        let(:search) { 'rams' }
        before do
          Item.where(type: 'Articulate').first.update(title: 'Ramsay')
          create(:presentation_item, title: 'My Exam')
        end
        it 'returns presentations against keywords' do
          expect(subject.length).to eq(1)
        end
      end
    end

    context 'with a slideshow type search' do
      let(:type_search) { 'Slideshow' }
      it 'returns active slideshows' do
        create(:slideshow, active: false)
        expect(subject.length).to eq(1)
      end

      context 'with a keyword search' do
        let(:search) { 'rams' }
        before do
          Slideshow.first.update(title: 'Ramsay')
          create(:slideshow, title: 'My Exam')
        end
        it 'returns slideshows against keywords' do
          expect(subject.length).to eq(1)
        end
      end
    end

    context 'with empty search and type search params' do
      let(:type_search) { nil }
      let(:search) { nil }

      it 'returns all' do
        expect(subject.length).to eq(4)
      end
    end
  end
end
