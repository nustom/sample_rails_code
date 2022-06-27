require 'rails_helper'

RSpec.describe Admin::LiveVideoConferenceFacade do
  let(:params) { {} }
  let(:live_video_conference) { create(:live_video_conference) }

  subject { described_class.new(params) }

  it '#form' do
    expect(subject.form).to be_instance_of Admin::LiveVideoConferenceForm
  end

  it '#criteria_facade' do
    expect(subject.criteria_facade).to be_instance_of Admin::VideoConferenceCriteriaFacade
  end

  context 'initialize a new live video conference' do
    it '#live_video_conference' do
      expect(subject.live_video_conference.new_record?).to be_truthy
    end
  end

  context 'successfully save a live video conference' do
    let(:params) do
      {
        admin_live_video_conference: {
          title: 'a live video conference',
          assessor_instruction: 'Assessor instructions',
          student_instruction: 'Student instructions',
          threshold: 3,
          rebooking_fee: 50
        }
      }
    end
    it '#save' do
      expect(subject.save).to be_truthy
      expect(LiveVideoConference.last.threshold).to eq 3
    end
  end

  context 'failed to save a live video conference when title is blank' do
    let(:params) do
      {
        admin_live_video_conference: {
          assessor_instruction: 'Assessor instructions',
          student_instruction: 'Student instructions'
        }
      }
    end
    it '#save' do
      expect(subject.save).to be_falsy
      expect(subject.form.errors.any?).to be_truthy
    end
  end

  context 'update a live video conference' do
    let(:params) do
      {
        admin_live_video_conference: {
          title: 'updated the live video conference',
          threshold: 1
        },
        id: live_video_conference.id
      }
    end

    it '#live_video_conference' do
      expect(subject.live_video_conference.new_record?).to be_falsy
    end

    it '#save' do
      expect(subject.save).to be_truthy
      live_video_conference.reload
      expect(live_video_conference.title).to eq 'updated the live video conference'
      expect(live_video_conference.threshold).to eq 1
    end
  end
end
