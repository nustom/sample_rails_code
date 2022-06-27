require 'rails_helper'

describe Admin::CourseFeedbackSearchService do
  let(:course) { create(:course_with_version) }
  let(:course_version) { course.course_versions.last }
  let(:search_params) { {} }

  subject { described_class.new(course, search_params) }

  describe '#retrieve' do
    context 'with no data' do
      it 'returns an empty result' do
        expect(subject.retrieve).to be_empty
      end
    end

    context 'when no filter is applied' do
      it 'returns only enrols with feedback from the selected course' do
        create(:enrol)
        create(:enrol, course_version: course_version)

        enrol1 = create(:enrol, course_version: course_version)
        enrol2 = create(:enrol, course_version: course_version)
        create(:enrol_feedback, :with_upload, enrol: enrol1)
        create(:enrol_feedback, enrol: enrol2)

        expect(subject.retrieve).to match_array([enrol1, enrol2])
      end

      context 'when there is a student without a user' do
        it 'does not return the feedback for that student' do
          enrol1 = create(:enrol, course_version: course_version)
          student = create(:student)
          student.update(user_id: nil)
          enrol2 = create(:enrol, course_version: course_version, student: student)
          create(:enrol_feedback, :with_upload, enrol: enrol1)
          create(:enrol_feedback, enrol: enrol2)
          expect(subject.retrieve).to match_array([enrol1])
        end
      end
    end

    context 'when the satisfaction level is applied' do
      it 'returns the approved ones' do
        enrol1 = create(:enrol, course_version: course_version)
        enrol2 = create(:enrol, course_version: course_version)
        create(:enrol_feedback, enrol: enrol1, approved: true)
        create(:enrol_feedback, enrol: enrol2, approved: false)

        service = described_class.new(course, satisfied: 'true')
        expect(service.retrieve).to match_array([enrol1])
      end

      it 'returns the not approved ones' do
        enrol1 = create(:enrol, course_version: course_version)
        enrol2 = create(:enrol, course_version: course_version)
        create(:enrol_feedback, enrol: enrol1, approved: true)
        create(:enrol_feedback, enrol: enrol2, approved: false)

        service = described_class.new(course, satisfied: 'false')
        expect(service.retrieve).to match_array([enrol2])
      end

      it 'returns enrols independent of feedback status' do
        enrol1 = create(:enrol, course_version: course_version)
        enrol2 = create(:enrol, course_version: course_version)
        enrol3 = create(:enrol)
        create(:enrol_feedback, enrol: enrol1, approved: true)
        create(:enrol_feedback, enrol: enrol2, approved: false)
        create(:enrol_feedback, enrol: enrol3)

        service = described_class.new(course, satisfied: '')
        expect(service.retrieve).to match_array([enrol1, enrol2])
      end
    end

    context 'when the feedback with videos filter is applied' do
      it 'returns an empty result if no feedback contains a video' do
        enrol1 = create(:enrol, course_version: course_version)
        create(:enrol_feedback, enrol: enrol1, approved: true)

        service = described_class.new(course, with_video: 'true')
        expect(service.retrieve).to be_empty
      end

      it 'returns enrols with video feedbacks' do
        enrol1 = create(:enrol, course_version: course_version)
        enrol2 = create(:enrol, course_version: course_version)
        create(:enrol_feedback, enrol: enrol1)
        create(:enrol_feedback, :with_upload, enrol: enrol2)

        service = described_class.new(course, with_video: 'true')
        expect(service.retrieve).to match_array([enrol2])
      end
    end

    context 'when video and satisfaction level are applied' do
      it 'returns enrols with video feedbacks and approved' do
        enrol1 = create(:enrol, course_version: course_version)
        enrol2 = create(:enrol, course_version: course_version)
        enrol3 = create(:enrol, course_version: course_version)
        create(:enrol_feedback, enrol: enrol1, approved: true)
        create(:enrol_feedback, enrol: enrol2, approved: false)
        create(:enrol_feedback, :with_upload, enrol: enrol3, approved: true)

        service = described_class.new(course, with_video: 'true')
        expect(service.retrieve).to match_array([enrol3])
      end
    end
  end
end
