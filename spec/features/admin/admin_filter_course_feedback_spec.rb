require 'rails_helper'

feature 'Admin filter course feedback' do
  let(:admin_user) { create(:admin_user) }
  let(:course) { create(:course_with_live_version) }
  let(:course_version) { course.course_versions.last }

  let!(:enrol1) { create(:enrol, course_version: course_version) }
  let!(:feedback_positive) { create(:enrol_feedback, enrol: enrol1) }

  let!(:enrol2) { create(:enrol, course_version: course_version) }
  let!(:feedback_video) { create(:enrol_feedback, :with_upload, enrol: enrol2) }

  let!(:enrol3) { create(:enrol, course_version: course_version) }
  let!(:feedback_negative) { create(:enrol_feedback, enrol: enrol3, approved: false) }

  before do
    login_user(admin_user)
    visit admin_course_edit_feedback_tab_path(course)
  end

  scenario 'when only positive feedback is displayed' do
    select 'Satisfied', from: 'satisfied'
    click_button 'Filter'

    expect(page).not_to have_content(feedback_negative.description)
    expect(page).to have_content(feedback_positive.description)
  end

  scenario 'when only negative feedback is displayed' do
    select 'Unsatisfied', from: 'satisfied'
    click_button 'Filter'

    expect(page).to have_content(feedback_negative.description)
    expect(page).not_to have_content(feedback_positive.description)
  end

  scenario 'when only feedback with video is displayed' do
    check 'with_video'
    click_button 'Filter'

    expect(page).not_to have_content(feedback_negative.description)
    expect(page).not_to have_content(feedback_positive.description)
    expect(page).to have_content(feedback_video.description)
  end
end
