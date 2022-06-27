require 'rails_helper'

RSpec.describe Admin::EnrolReportFacade do
  let(:params) { {} }
  let(:course_one) { create(:course) }
  let(:course_version_one) { create(:course_version, course: course_one) }
  let(:course_two) { create(:course) }
  let(:course_version_two) { create(:course_version, course: course_two) }
  let(:course_inactive) { create(:course, active: false) }
  let(:course_version_inactive) { create(:course_version, course: course_inactive) }
  let(:student1) { create(:student) }
  let(:student2) { create(:student) }
  let!(:enrol_not_complete) { create(:enrol, student: student1, status: nil, course_version: course_version_one) }
  let!(:enrol_complete) { create(:enrol, student: student2, status: :complete, course_version: course_version_two) }
  let!(:enrol_with_inactive_course) { create(:enrol, student: student2, course_version: course_version_inactive) }

  subject { described_class.new(params) }

  it 'only list active courses' do
    expect(subject.courses.map { |c| c[1] }).to match_array([course_one.id, course_two.id])
  end

  context 'search by course' do
    let(:params) do
      {
        enrol_report: {
          course_id: course_one.id
        }
      }
    end

    it '#searched_enrolments' do
      expect(subject.searched_enrolments.map(&:id)).to eq [enrol_not_complete.id]
    end
  end

  context 'include the complete enrolments' do
    let!(:enrol_not_complete) { create(:enrol, student: student1, status: nil, course_version: course_version_one) }
    let!(:enrol_complete) { create(:enrol, student: student2, status: :complete, course_version: course_version_one) }

    let(:params) do
      {
        enrol_report: {
          course_id: course_one.id,
          include_completed: '1'
        }
      }
    end

    it '#searched_enrolments' do
      expect(subject.searched_enrolments.map(&:id)).to match_array [enrol_not_complete.id, enrol_complete.id]
    end
  end

  context 'search course and include the complete enrolments' do
    let(:params) do
      {
        enrol_report: {
          course_id: course_two.id,
          include_completed: '1'
        }
      }
    end

    it '#searched_enrolments' do
      expect(subject.searched_enrolments.map(&:id)).to eq [enrol_complete.id]
    end
  end
end
