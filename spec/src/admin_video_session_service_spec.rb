require 'rails_helper'

RSpec.describe Admin::VideoSessionsFacade do
  let(:params) { {} }
  let(:user) { build(:user, timezone: 'UTC') }

  subject { described_class.new(params, user) }

  let!(:video_sessions) do
    BookingVideoConference::SUBMITTED_STATUS.map do |status|
      create(:booking_video_conference, status: status)
    end
  end

  context 'video sessions' do
    let(:real_results) { subject.video_sessions.pluck(:id) }
    it 'returns all video sessions' do
      expect(real_results).to match_array video_sessions.map(&:id)
    end

    context 'search video sessions by trainer' do
      let(:instructor) { create(:instructor) }
      let(:params) { { instructor_id: instructor.id } }
      before do
        video_sessions.first.update_attributes(instructor_id: instructor.id)
      end

      it 'returns the sessions matching the trainer' do
        expect(real_results).to match_array [video_sessions.first.id]
      end
    end

    context 'search video sessions by course' do
      let(:course) { create(:course) }
      let(:course_version) { create(:course_version, course: course) }
      let(:enrol) { create(:enrol, course_version: course_version) }
      let(:params) { { course_id: course.id } }
      before do
        video_sessions.first.update_attributes(enrol_id: enrol.id)
      end

      it 'returns the sessions matching the course' do
        expect(real_results).to match_array [video_sessions.first.id]
      end
    end

    context 'search video sessions by determined status' do
      let(:params) { { determined_status: 'not_prepared' } }
      let(:not_prepared_session) { video_sessions.detect(&:not_prepared?) }

      it 'returns the sessions matching the determined status' do
        expect(real_results).to match_array [not_prepared_session.id]
      end
    end

    context 'search video sessions by time status' do
      context 'upcoming sessions' do
        let(:params) { { time_status: 'Upcoming' } }

        it 'returns the sessions matching the time period' do
          expect(real_results).to match_array video_sessions.map(&:id)
        end
      end

      context 'passed sessions' do
        let(:params) { { time_status: 'Passed' } }
        let(:end_date_time) { TimezoneService.now_local_backward(2.hours).to_i }
        let!(:padded_video_session) do
          create(:booking_video_conference,
                 status: :not_prepared,
                 start_date_time: end_date_time - 30 * 60,
                 end_date_time: end_date_time)
        end

        it 'returns the sessions match the course' do
          expect(real_results).to match_array [padded_video_session.id]
        end
      end
    end
  end
end
